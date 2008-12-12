# packages/lorsm/www/delivery/toc.tcl

ad_page_contract {

    Course Delivery Table of Content

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-09
    @arch-tag 553390f0-450e-48db-99f0-c5dcb17978b8
    @cvs-id $Id$
} {
    man_id:integer,notnull
    user_id:integer,notnull
} -properties {
} -validate {
} -errors {
}

#### generic for this detail level

set page_title "Inspecting single user tracks"

set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]
set man_id [ ad_get_client_property trackingrte man_id ]
set classname [dotlrn_community::get_community_name $community_id]
set man_name [lorsm::get_course_name -manifest_id $man_id]
#acs_user::get -user_id $user_id -array user
#set student_id $user(username)
set student_name [person::name -person_id $user_id]

set context [list "$classname,$man_name,$student_name"]

ad_set_client_property trackingrte currentlydrilleduser $user_id


######

set table_item ""
set orgs_list ""
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
               -package_key "file-storage"]

set track_id [lorsm::track::istrackable \
                -course_id $man_id \
                -package_id $package_id]

set extra_vars fs_local_package_id

db_foreach organizations {} {

    set indent [expr $indent +1]
    set missing_text "[_ lorsm.Nothing_here]"

    set table_extra_html { width="100%" }
    # the table_def isn't quite neat as I'd like to, but it does the job for a
    # simple indexing for delivery.
#    set table_def {
#   { title "" "no_sort" "<td>Item: $item_id $indent [if {![empty_string_p $identifierref]} {set href \"<a href='$item_id' target='body' title='$item_title'>$item_title</a>\"} else {set href \"AAA $item_title\"}]</td>" }
#    }

    regsub -all {[\{\}]} $org_title "" org_title

    append orgs_list "<HR><TABLE $table_extra_html BORDER=0>"
    append orgs_list "<TH ALIGN=left colspan=6> $org_title (id: $org_id)
        </TH></TR>"

    set indent_items [lorsm::get_items_indent -org_id $org_id]

    db_foreach organization_item {} {

        foreach indent_item $indent_items {
            set indent_item_id [lindex $indent_item 0]
            set indent_indent [lindex $indent_item 1]
            if { [string equal $indent_item_id $ims_item_id] } {
                set indent $indent_indent
            }
        }

        set table_item ""

        for {set x 0} {$x<$indent} {incr x} {
            append table_item "<td width=5%></td>"
        }

        append table_item "<td colspan=99><table width=100% border=0><tr>"

        if { [empty_string_p $identifierref] } {
            append table_item "<td colspan=6>Item: $ims_item_id $indent
                $item_title"
            #set table_item "<td colspan=6>Item: $item_id $indent AAA $item_title</td>"
        } else {
            #set table_item "<td colspan=6 bgcolor=#aca>Item: $item_id $indent <a href='$item_id' target='body' title='$item_title'>[string trim $item_title]</a>"
            append table_item "<td colspan=6>[string trim $item_title],
                (id: $ims_item_id)"
        }
    #    set table_item [concat $table_item [ad_table -Tmissing_text $missing_text -Textra_vars {fs_local_package_id track_id}  -Ttable_extra_html $table_extra_html $table_def]]
        #set table_item [concat $table_item [ad_table -Tmissing_text $missing_text -Textra_vars {fs_local_package_id track_id}  -Ttable_extra_html $table_extra_html $table_def]]

        append orgs_list [string trim $table_item]
        set item_table ""

        db_foreach student_activity {} {
            set cut_start_time [string range $start_time 0 18]
            set total_total_time [expr $total_time+$session_time]
            set edit_url [export_vars -base "drill-student-singletrack" \
                {track_id}]
            set drill_url [export_vars -base "drill-student-singletrack" \
                {track_id}]

            append item_table "<td width=9%>"
            append item_table "$score_raw</td>"
            append item_table "<td> $lesson_status </td>"
            append item_table "<td> $total_total_time \"</td>"
            append item_table "<td> $cut_start_time </td>"
            append item_table "<td> <a href=$drill_url>$track_id</a></td>"
            append item_table "</tr>"

        }

        if { [empty_string_p $item_table] } {
            append orgs_list "<I> :     No RTE scorm data </I></td>"
            append orgs_list "</tr>"

        } else {
            append orgs_list "</td></tr><td width=10%></td><td>"
            append orgs_list "<table width=100% border=1 cellpadding=0
                cellspacing=0 bordercolor=#fff>"
            append orgs_list "<td>score</td><td>status</td><td>total time</td>
                <td>first visit</td><td>detail sessions</td></tr>"
            append orgs_list $item_table
            append orgs_list "</table>"
            append orgs_list "</td></tr>"
        }

        append orgs_list "</table>"
        append orgs_list "</td></tr>"
    }

    append orgs_list "</td></tr>"
    append orgs_list "</TABLE>"
}
