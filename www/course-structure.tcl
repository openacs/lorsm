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
set context [list "Course Structure"]
set title "Course Structure"

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
	   acs.creation_user,
	   acs.creation_date,
	   acs.context_id
    from
           ims_cp_manifests cp, acs_objects acs
    where 
           cp.man_id = acs.object_id
	   and  cp.man_id = :man_id
           and  cp.parent_man_id = 0"]} {

    # Sets the variable for display. 
    set display 1
    
    # Course Name
    if {[empty_string_p $course_name]} {
	set course_name "No course Name"
    } 

    # Version
    if {[empty_string_p $version]} {
	set version "No version Available"
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


append orgs_list "<table class=\"list\" cellpadding=\"3\" cellspacing=\"1\">"
append orgs_list "<tr class=\"list-header\">
        <th class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">Organization</th>
        <th class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">Metadata?</th>
        <th class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">Items</th>
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


    append orgs_list "<tr class=\"list-even\"><td valign=\"top\">$org_title</td><td valign=\"top\" align=\"center\">$hasmetadata</td><td>"

    set indent [expr $indent +1]
    set missing_text "Nothing here"

    set table_extra_html { width="100%" }
    set table_def {
	{ title "" "no_sort" "<td>$indent[if {![empty_string_p $identifierref]} {set href \"<a href='[apm_package_url_from_id $fs_package_id]view/[db_string select_folder_key {select key from fs_folders where folder_id = :folder_id}]/[lorsm::fix_url -url $identifierref]'>$item_title</a>\"} else {set href $item_title}]</td>" }
	{ metadata "" "no_sort" "<td align=\"center\">[if {$hasmetadata == \"f\"} {set hasmetadata \"\"} else {set hasmetadata \"<a href=md/?ims_md_id=$item_id>Metadata\"}]</a></td>" }
    }

    set table_item [ad_table -Tmissing_text $missing_text  -Ttable_extra_html $table_extra_html blah {
        SELECT
		o.object_id,
 		repeat('&nbsp;', (tree_level(tree_sortkey) - :indent)* 5) as indent,
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
                tree_sortkey, object_id


    } $table_def]

    append orgs_list "$table_item"


    append orgs_list "</td></tr>"

} if_no_rows {
    append orgs_list "<tr class=\"list-odd\"><td></td></tr>"
}

append orgs_list "</table>"




