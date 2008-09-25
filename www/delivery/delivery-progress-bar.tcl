# packages/lorsm/www/delivery/delivery-context-bar.tcl

ad_page_contract {
    
} {
    {__include ""}
    {__include_vars ""}
    {next_item_id ""}
    track_id:optional
} -properties {
} -validate {
} -errors {
}

set track_id [ad_get_client_property lorsm studenttrack]
ns_log notice "DAVEB LORSM BEFORE TRACK_ID='${track_id}'"
if {![info exists man_id] || $man_id eq ""} {
    set man_id [ad_get_client_property lorsm man_id]
}
if {![info exists item_id]} {
    set item_id [ad_get_client_property lorsm ims_id]
}
ns_log notice "DEBUG:: item_id $item_id"
set community_id [dotlrn_community::get_community_id]
set user_id [ad_conn user_id]
set lorsm_url [dotlrn_community::get_community_url $community_id]lorsm/delivery

set package_id [site_node::get_element -url $lorsm_url -element package_id]

# return_url
set return_url [dotlrn_community::get_community_url [dotlrn_community::get_community_id]]

set item_list [lorsm::get_item_list $man_id $user_id]

set last_item_viewed [db_string select_last_item_viewed {    
	select ims_item_id
	from views_views v,
	ims_cp_items i,
	ims_cp_organizations o
	where v.viewer_id = :user_id
	and v.object_id = i.ims_item_id
	and i.org_id = o.org_id
	and o.man_id = :man_id
	order by v.last_viewed desc
		limit 1
} -default ""]

set first_item_id [lindex $item_list 0]
set first_item_url "<a href=\"[export_vars -base "${lorsm_url}/record-view" -url {{item_id $first_item_id} man_id}]\"><img src=\"${lorsm_url}/Images/home.png\" border=\"0\" title=\"home\" onclick=\"window.location.reload()\"></a>"
set curr_index [expr [lsearch -exact $item_list $item_id]]
set next_link_text [_ lorsm.Next]

set track_p 1

if {$curr_index < 0} {
    # start course
    # we want the next_url to be the first item
    set curr_index -1
    # do we have a custom start page?
    set item_id [lorsm::get_custom_page_ims_item_id -man_id $man_id -type start]
    if {$item_id eq ""} {
	set __include "/packages/lorsm/lib/start"
	set page_title [lorsm::get_course_name -manifest_id $man_id]
    } else {
	ad_set_client_property lorsm ims_id $item_id
	set __include /packages/lorsm/lib/default
	set page_title [db_string get_title "select item_title from ims_cp_items where ims_item_id=:item_id" -default ""]
    }
    set next_link_text [_ lorsm.Begin]
    set track_p 0
}
# Student tracking
if {[lorsm::track::istrackable -course_id $man_id -package_id $package_id] \
    && $track_p && ($track_id == 0 || $track_id eq "")} {
    
    set track_id [lorsm::track::new \
		      -user_id $user_id \
		      -community_id $community_id \
		      -course_id $man_id]
    ad_set_client_property lorsm studenttrack $track_id
} elseif {$track_id eq ""} {
    set track_id 0
}
ns_log notice "DAVEB LORSM AFTER TRACK_ID='${track_id}'"
set prev_item_id [lindex $item_list [expr $curr_index - 1]]
set next_item_id [lindex $item_list [expr $curr_index + 1]]
set prev_url "<a href=\"[export_vars -base "${lorsm_url}/record-view" -url {{item_id $prev_item_id} man_id}]\"><img src=\"${lorsm_url}/Images/prev.png\" border=\"0\" title=\"next\" onclick=\"window.location.reload()\"></a>"
set next_url [export_vars -base "${lorsm_url}/record-view" -url {{item_id $next_item_id} track_id man_id}]

set prev_title [db_string get_title "select item_title from ims_cp_items where ims_item_id=:prev_item_id" -default ""]
set next_title [db_string get_title "select item_title from ims_cp_items where ims_item_id=:next_item_id" -default ""]
set current_title [db_string get_title "select item_title from ims_cp_items where ims_item_id=:item_id" -default ""]

set progress_total_pages [llength $item_list]
set progress_current_page [expr {$curr_index + 1}]
set last_item_p [expr {$curr_index == [expr {[llength $item_list] - 1}]}]
if {[string match "*assessment*" $__include] && ![string match "*assessment/lib/session*" $__include]} {
    set show_next 0
    set header_stuff {<link rel="stylesheet" type="text/css" href="/resources/assessment/crbForms.css" media="all">
      <link rel="stylesheet" type="text/css" href="/resources/assessment/assessment.css" media="all">}
} else {
    if { $next_item_id eq "" } {
	# check for end page
	set next_url ${lorsm_url}/end
	set last_item_p 0
    }
    set header_stuff ""
    set show_next 1
}

if {$__include eq "/packages/lorsm/lib/end"} {
    set item_id [lorsm::get_custom_page_ims_item_id -man_id $man_id -type end]
    if {$item_id ne ""} {
	ad_set_client_property lorsm ims_id $item_id
	set __include /packages/lorsm/lib/default
	set page_title [db_string get_title "select item_title from ims_cp_items where ims_item_id=:item_id" -default ""]
    }
    set next_url [export_vars -base exit {man_id track_id return_url}]
	set last_item_p 1

}

set include_content [template::adp_include $__include $__include_vars]
regsub -all {<a(.*?)>} $include_content {<a target=\"_new\" \1 >} include_content

if {$current_title ne ""} {
    set page_title $current_title
}