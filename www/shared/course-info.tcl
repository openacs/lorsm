# packages/lorsm/www/shared/course-info.tcl

ad_page_contract {
    
     Previews course
     
     @author Ernie Ghiglione (ErnieG@mm.st)
     @creation-date 2004-07-09
     @arch-tag: 9687443a-686e-4784-9702-5c00ee0bdc88
     @cvs-id $Id$
 } {
     man_id:integer
} -properties {
} -validate {
} -errors {
}


set context [list [list [export_vars -base .] "Shared Courses"] "Preview Course"]
set community_id [dotlrn_community::get_community_id]

set title "[_ lorsm.Preview_Course_1]"

# Permissions
dotlrn::require_user_admin_community -user_id [ad_conn user_id] -community_id $community_id

# In order to share courses across classes, we need to share
# file-storage objects across file-storage instances. This has been
# proven to be really tricky. But here we pass the fs_package_id for
# the current community, so we don't have to have permissions for
# other instances of file-storages of other classes.  See
# documentation for further details.


set fs_local_package_id [site_node_apm_integration::get_child_package_id \
		       -package_id [dotlrn_community::get_package_id $community_id] \
		       -package_key "file-storage"\
		      ]

# Checks whether this course is already in use on this community


set active [db_0or1row check ""]



if {[db_0or1row manifest ""]} {

    # Sets the variable for display. 
    set display 1
    
    # Course Name
    if {[empty_string_p $course_name]} {
	set course_name "[_ lorsm.No_course_Name]"
    } 

    # Version
    if {[empty_string_p $version]} {
	set version "[_ lorsm._No]"
    } 
    
    # Created By
    set created_by [person::name -person_id $creation_user]

    # Creation Date
    set creation_date [lc_time_fmt $creation_date "%x %X"]

    # Check for submanifests
    if {[db_0or1row submans ""]} {
    } else {
	set submanifests 0
    }


} else {

    set display 0
    
}


append orgs_list "<table class=\"list\" cellpadding=\"3\" cellspacing=\"1\" width=\"100%\">"
append orgs_list "<tr class=\"list-header\">
        <th class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">Organization</th>
        <th class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">Metadata?</th>
        <th class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">Items</th>
    </tr>
"
db_foreach organizations {} {

    set total_items [db_string items_count {select count(*) from ims_cp_items where org_id=:org_id} -default 0]


    append orgs_list "<tr class=\"list-even\"><td valign=\"top\" width=\"20%\">$org_title</td><td valign=\"top\" align=\"center\" width=\"5%\">$hasmetadata</td><td>"

    set indent [expr $indent +1]
    set missing_text "Nothing here"
    set return_url [export_vars -base [ns_conn url] man_id]
    set table_extra_html { width="100%" }
   
    set track_id 0
    set table_extra_vars {return_url fs_local_package_id track_id}
    set table_def {
	{ title "\#lorsm.Item_Name\#" "no_sort" "<td>
           [set indent  \"\"
                      for { set i 0 } { $i < [expr $indent -1]} { incr i } {
                      append indent \"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"
                      }
           if {![empty_string_p $identifierref]} {set href \"<a href='[lorsm::fix_href2 -item_id $item_id -identifierref $identifierref -fs_package_id $fs_package_id -fs_local_package_id $fs_local_package_id -folder_id $folder_id -type $type -track_id $track_id]' target='body' title='$item_title'>$item_title</a>\"} else {set href $item_title}]</td>"	}
	{ metadata "\#lorsm.Metadata_1\#" "no_sort" "<td align=\"center\">[if {$hasmetadata == \"f\"} {set hasmetadata \"No\"} else {set hasmetadata \"<a href=md/?ims_md_id=$item_id>Metadata\"}]</a></td>" }
	{ type   "\#lorsm.Type\#" "no_sort" "<td align=\"center\">$type</td>" }
    }

    set table_item [ad_table -Tmissing_text $missing_text -Textra_vars $table_extra_vars -Theader_row_extra "style=\"background-color: #e0e0e0; font-weight: bold;\" class=\"list-header\"" -Ttable_extra_html $table_extra_html blah { } $table_def]

    append orgs_list "$table_item"


    append orgs_list "</td></tr>"

} if_no_rows {
    append orgs_list "<tr class=\"list-odd\"><td></td></tr>"
}

append orgs_list "</table>"

set shared_url  [export_vars -base add-shared-course {man_id}]


