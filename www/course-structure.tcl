# packages/lorsm/www/course_structure.tcl

ad_page_contract {
    
    View Manifest Course Structure
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-03-31
    @arch-tag 208f2801-d110-45d3-9401-d5eae1f72c93
    @cvs-id  $Id$
} {
    man_id:integer,notnull	
} -properties {
} -validate {
} -errors {
}

set package_id [ad_conn package_id]

ad_proc -public getFolderKey {
    {-object_id:required}
} {
    Gets the Folderkey for a file-storage folder_id

    @option object_id Folder_id for file-storage folder
    @author Ernie Ghiglione (ErnieG@mm.st)

} {
    return [db_string select_folder_key "select key from fs_folders where object_id = :object_id"]
}

# set context & title
set context [list "[_ lorsm.Course_Structure]"]
set title "[_ lorsm.Course_Structure]"


if {[db_0or1row manifest "
    select 
           cp.man_id,
           cp.course_name,
           cp.identifier,
           cp.version,
           text 'Yes' as hello,
           case
              when hasmetadata = 't' then 'Yes'
              else 'No'
           end as man_metadata,
           case 
              when isscorm = 't' then 'Yes'
              else 'No'
           end as isscorm,
           cp.fs_package_id,
           cp.folder_id,
	   cp.isshared,
	   acs.creation_user,
	   acs.creation_date,
	   acs.context_id,
           cpmc.isenabled,
           cpmc.istrackable
    from
           ims_cp_manifests cp, acs_objects acs, ims_cp_manifest_class cpmc
    where 
           cp.man_id = acs.object_id
	   and  cp.man_id = :man_id
           and  cp.man_id = cpmc.man_id
           and  cpmc.lorsm_instance_id = :package_id
           and  cp.parent_man_id = 0"]} {

    # Sets the variable for display. 
    set display 1
    
    # Course Name
    if {[empty_string_p $course_name]} {
	set course_name "[_ lorsm.No_course_Name]"
    } 

    # Version
    if {[empty_string_p $version]} {
	set version "[_ lorsm.No_version_Available]"
    } 
    
    # Instance
    set instance [apm_package_key_from_id $fs_package_id]

    # Folder
    set folder [apm_package_url_from_id $fs_package_id]?[export_vars folder_id]

    # Created By
    set created_by [person::name -person_id $creation_user]

    # Creation Date
    set creation_date [lc_time_fmt $creation_date "%x %X"]

    # Check for submanifests
    if {[db_0or1row submans "
           select 
                count(*) as submanifests 
           from 
                ims_cp_manifests 
           where 
                man_id = :man_id
              and
                parent_man_id = :man_id"]} {
    } else {
	set submanifests 0
    }


} else {

    set display 0
    
}


append orgs_list "<table class=\"list\" cellpadding=\"3\" cellspacing=\"1\" width=\"100%\">"
append orgs_list "<tr class=\"list-header\">
        <th class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">[_ lorsm.Organization]</th>
        <th class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">[_ lorsm.Metadata_1]</th>
        <th class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">[_ lorsm.Items]</th>
    </tr>
"
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


    append orgs_list "<tr class=\"list-even\"><td valign=\"top\" width=\"20%\">$org_title</td><td valign=\"top\" align=\"center\" width=\"5%\">$hasmetadata</td><td>"

    set indent [expr $indent +1]
    set missing_text "[_ lorsm.Nothing_here]"
    set return_url [export_vars -base [ns_conn url] man_id]
    set table_extra_html { width="100%" }
   
    set table_extra_vars {return_url}
    set table_def {
	{ title "[_ lorsm.Item_Name]" "no_sort" "<td>$indent[if {![empty_string_p $identifierref]} {set href \"<a href='[apm_package_url_from_id $fs_package_id]view/[db_string select_folder_key {select key from fs_folders where folder_id = :folder_id}]/[lorsm::fix_url -url $identifierref]'>$item_title</a>\"} else {set href $item_title}]</td>" }
	{ Edit "[_ lorsm.Edit]" "no_sort" "<td align=\"center\">[if {![empty_string_p $identifierref]} {set href \"<a href=\'[export_vars -base edit-content {identifierref folder_id return_url fs_package_id}]\'>[_ lorsm.Edit_1]</a></td>\"}]"}
	{ metadata "[_ lorsm.Metadata_1]" "no_sort" "<td align=\"center\">[if {$hasmetadata == \"f\"} {set hasmetadata \"<a href=md?ims_md_id=$item_id>No\"} else {set hasmetadata \"<a href=md/?ims_md_id=$item_id>Yes\"}]</a></td>" }
	{ type   "[_ lorsm.Type]" "no_sort" "<td align=\"center\">$type</td>" }
	{ shared "[_ lorsm.Is_Shared]" "no_sort" "<td align=\"center\">[if {$isshared == false} {set ret \"No\"}]</td>" }
    }

    set table_item [ad_table -Tmissing_text $missing_text -Textra_vars $table_extra_vars -Theader_row_extra "style=\"background-color: #e0e0e0; font-weight: bold;\" class=\"list-header\"" -Ttable_extra_html $table_extra_html blah {
        SELECT
		o.object_id,
 		repeat('&nbsp;', (tree_level(tree_sortkey) - :indent)* 3) as indent,
		i.item_id,
                i.title as item_title,
                i.hasmetadata,
                i.org_id,
                case
                    when i.isshared = 'f' then (
						'false'
						) 
	            else 'true'
                end as isshared,
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
                tree_sortkey, object_id


    } $table_def]

    append orgs_list "$table_item"


    append orgs_list "</td></tr>"

} if_no_rows {
    append orgs_list "<tr class=\"list-odd\"><td></td></tr>"
}

append orgs_list "</table>"

set enabler_url [export_vars -base enabler {man_id}]
set tracker_url [export_vars -base tracker {man_id}]
set sharer_url  [export_vars -base sharer {man_id folder_id return_url}]

#Presentation-related fields
if {[db_0or1row course_presentation_format "
    select presentation_name as pformat from lors_available_presentation_formats where presentation_id=(select presentation_id from ims_cp_manifests where man_id=:man_id);
" ] } { } else {
	set pformat #lorsm.None#
}
