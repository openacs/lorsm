ad_page_contract {
    This page lists all the students for whom we have data in lorsm_cmi_core for a given course

    @author Michele Slocovich (michele@sii.it)
} {
    man_id:integer,notnull
} -properties {
} -validate {
} -errors {
}

set title "Listing students tracks for a course"

set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]
set classname [dotlrn_community::get_community_name $community_id]
set man_name [lorsm::get_course_name -manifest_id $man_id]

ad_set_client_property trackingrte man_id $man_id

set context [list "$classname,$man_name"]

