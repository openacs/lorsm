ad_page_contract {
    This page lists tracks from lorsm_student_track and referring record from lorsm_cmi_core.

    @author Michele Slocovich (michele@sii.it)
} {
    track_id:integer,notnull
} -properties {
} -validate {
} -errors {
}

set page_title "Inspecting single track for user"

set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]
set man_id [ ad_get_client_property trackingrte man_id ]
set user_id [ad_get_client_property trackingrte currentlydrilleduser]
#acs_user::get -user_id $user_id -array user
#set student_id $user(username)
set student_name [person::name -person_id $user_id]
set classname [dotlrn_community::get_community_name $community_id]
set man_name [lorsm::get_course_name -manifest_id $man_id]


set thistrack [ db_1row thiscmitrack  \
                "select *
                from lorsm_cmi_core
                where track_id=:track_id " ]

set thistrack $track_id

set context [list "$classname,$man_name,$student_name,session_id: $track_id"]

set numrows [ db_0or1row istherealready \
                "select min(lorsm.track_id) as mint from lorsm_cmi_core cmi, lorsm_student_track lorsm
                where lorsm.community_id=:community_id
                    and lorsm.course_id=:man_id
                    and user_id=:user_id
                    and lorsm.track_id=cmi.track_id
                    and lorsm.track_id>:track_id "]
# seems numrows always 1 when doing an aggregate query
if { $mint == "" } {
    set querypart ""
} else {
    set querypart " and lorsm.track_id < $mint "
}

template::list::create \
    -name student_track \
    -multirow student_track \
    -elements {
        course_name {
            link_url_col edit_url
            label "titolo"

        } user_id {
            label "student ID"
            display_eval {[person::name -person_id $user_id]}
            link_url_col drill_url

        } start_time {
            label "time student first entered course"

        } end_time {
            label "time student left course"

        } track_id {
            label "track_id (from lorsm_student_track)"
        }
    }

db_multirow student_track single_student_track \
    "select *
    from lorsm_student_track lorsm, ims_cp_manifests manif
    where lorsm.community_id=$community_id
        and lorsm.course_id=$man_id
        and (lorsm.track_id>=$track_id $querypart)
        and manif.man_id=$man_id
        and user_id=$user_id
    order by lorsm.track_id asc" \
    {
        set edit_url [export_vars -base "drill-student-singletrack" {track_id}]
        set drill_url [export_vars -base "drill-student-singletrack" {track_id}]
    }

