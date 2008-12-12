ad_page_contract {
    This page lists tracks for a give course for a certain student.

    @author Michele Slocovich (michele@sii.it)
} {
    user_id:integer,notnull
} -properties {
} -validate {
} -errors {
}

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

#   course_name {
#       label "titolo"
#   }
#   student_id {
#       label "student ID"
#                   display_eval {[person::name -person_id $user_id]}
#   }
###
template::list::create \
    -name student \
    -multirow student \
    -elements {
        item_title  { label "Title" }
        score_raw { label "Score - sent by sco" }
        total_total_time { label "Total time - sent by sco" }
        cut_start_time { label "Time student first entered course" }
        lesson_status { label "lesson status - sent by sco" }
        track_id {
            label "session_id. click for detail"
            link_url_col drill_url
        }
    }

#label "session_id (cmi.core.track_id=lorsm.studenttrack.track_id)"

db_multirow \
    -extend { edit_url drill_url total_total_time cut_start_time } \
    student single_student {} {
        set cut_start_time [string range $start_time 0 18]
        set total_total_time [expr $total_time+$session_time]
        set edit_url [export_vars -base "drill-student-singletrack" {track_id}]
        set drill_url [export_vars -base "drill-student-singletrack" {track_id}]
    }

