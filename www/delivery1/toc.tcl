# packages/lorsm/www/delivery/toc.tcl

ad_page_contract {
    
    Course Delivery Table of Content
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-09
    @arch-tag 553390f0-450e-48db-99f0-c5dcb17978b8
    @cvs-id $Id$
} {
    man_id:integer,notnull  
} -properties {
} -validate {
} -errors {
}

set table_item ""
set package_id [ad_conn package_id]

# In order to share courses across classes, we need to share
# file-storage objects across file-storage instances. This has been
# proven to be really tricky. But here we pass the fs_package_id for
# the current community, so we don't have to have permissions for
# other instances of file-storages of other classes.  See
# documentation for further details.

set community_id [dotlrn_community::get_community_id]
set fs_local_package_id [site_node_apm_integration::get_child_package_id \
		       -package_id [dotlrn_community::get_package_id $community_id] \
		       -package_key "file-storage"\
		      ]
set track_id [lorsm::track::istrackable -course_id $man_id -package_id $package_id]

set extra_vars fs_local_package_id


db_foreach organizations {
    select 
       org.org_id,
       org.title as org_title,
       org.hasmetadata,
       tree_level(o.tree_sortkey) as indent
    from
       ims_cp_organizations org, acs_objects o
    where
       org.org_id = o.object_id
     and
       man_id = :man_id
    order by
       org_id
} {

    set indent [expr $indent +1]
    set missing_text "[_ lorsm.Nothing_here]"

    set table_extra_html { width="100%" }
    # the table_def isn't quite neat as I'd like to, but it does the job for a
    # simple indexing for delivery. 
    set table_def {
	{ title "" "no_sort" "<td>$indent[if {![empty_string_p $identifierref]} {set href \"<a href='[lorsm::fix_href2 -item_id $item_id -identifierref $identifierref -fs_package_id $fs_package_id -fs_local_package_id $fs_local_package_id -folder_id $folder_id -type $type -track_id $track_id]' target='body' title='$item_title'>$item_title</a>\"} else {set href $item_title}]</td>" }
    }

    set table_item [concat $table_item [ad_table -Tmissing_text $missing_text -Textra_vars {fs_local_package_id track_id}  -Ttable_extra_html $table_extra_html blah {
        SELECT
		o.object_id,
 		repeat('&nbsp;', (tree_level(tree_sortkey) - :indent)* 2) as indent,
		i.item_id,
                i.title as item_title,
                i.hasmetadata,
                i.org_id,
                case 
		    when i.identifierref <> '' then (
						     SELECT
						      res.href 
						     FROM
						      ims_cp_items_to_resources i2r, 
						      ims_cp_resources res 
						     WHERE
						       i2r.res_id = res.res_id
						      AND
						       i2r.item_id = i.item_id 
						     )
                  else ''
                end as identifierref,
                case 
		    when i.identifierref <> '' then (
						     SELECT
						      res.type
						     FROM
						      ims_cp_items_to_resources i2r, 
						      ims_cp_resources res 
						     WHERE
						       i2r.res_id = res.res_id
						      AND
						       i2r.item_id = i.item_id 
						     )
                  else ''
                end as type,
                m.fs_package_id,
	        m.folder_id,
	        m.course_name
        FROM 
		acs_objects o, ims_cp_items i, ims_cp_manifests m
	WHERE 
		o.object_type = 'ims_item'
           AND
		i.org_id = :org_id
	   AND
		o.object_id = i.item_id
           AND
                m.man_id = :man_id
        ORDER BY 
                object_id, tree_sortkey


    } $table_def]]

    append orgs_list "$table_item"


    append orgs_list "</td></tr>"

} 


