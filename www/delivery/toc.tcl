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
    set missing_text "Nothing here"

    set table_extra_html { width="100%" }
    set table_def {
	{ title "" "no_sort" "<td>$indent[lorsm::fix_href -item_title $item_title -identifierref $identifierref -fs_package_id $fs_package_id -folder_id $folder_id]</td>" }
    }

    set table_item [concat $table_item [ad_table -Tmissing_text $missing_text  -Ttable_extra_html $table_extra_html blah {
        SELECT
		o.object_id,
 		repeat('&nbsp;', (tree_level(tree_sortkey) - :indent)* 4) as indent,
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


