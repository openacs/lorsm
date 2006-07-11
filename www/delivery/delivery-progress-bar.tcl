# packages/lorsm/www/delivery/delivery-context-bar.tcl

ad_page_contract {
    
} {
    {__include ""}
    {next_item_id ""}
    {man_id ""}
} -properties {
} -validate {
} -errors {
}
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

# Student tracking
set package_id [ad_conn package_id]
#if {[lorsm::track::istrackable -course_id $man_id -package_id $package_id]} {
    
#    set track_id [lorsm::track::new \
\#		      -user_id $user_id \
\#		      -community_id $community_id \
\#		      -course_id $man_id]
#} else {
    set track_id 0
#}

# return_url
set return_url [dotlrn_community::get_community_url [dotlrn_community::get_community_id]]

set item_list [lorsm::get_item_list $man_id $user_id]

set last_item_viewed [db_string select_last_item_viewed {    
	select ims_item_id
	from views v,
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
if {$item_id eq ""} {
    set item_id $first_item_id
    ad_returnredirect [export_vars -base ${lorsm_url}/record-view {man_id item_id}]
    ad_script_abort
}
#set curr_index [expr [lsearch -exact $item_list $last_item_viewed]]
set curr_index [expr [lsearch -exact $item_list $item_id]]
if {$curr_index < 1} {set curr_index 0}

set prev_item_id [lindex $item_list [expr $curr_index - 1]]
set next_item_id [lindex $item_list [expr $curr_index + 1]]
set prev_url "<a href=\"[export_vars -base "${lorsm_url}/record-view" -url {{item_id $prev_item_id} man_id}]\"><img src=\"${lorsm_url}/Images/prev.png\" border=\"0\" title=\"next\" onclick=\"window.location.reload()\"></a>"
set next_url [export_vars -base "${lorsm_url}/record-view" -url {{item_id $next_item_id} man_id}]

set prev_title [db_string get_title "select item_title from ims_cp_items where ims_item_id=:prev_item_id" -default ""]
set next_title [db_string get_title "select item_title from ims_cp_items where ims_item_id=:next_item_id" -default ""]
set current_title [db_string get_title "select item_title from ims_cp_items where ims_item_id=:last_item_viewed" -default ""]

set progress_list [template::util::number_list [llength $item_list] 1]
set progress_index [expr {$curr_index + 1}]

if {[string match "*assessment*" $__include] && ![string match "*assessment/lib/session*" $__include]} {
    set show_next 0
} else {
    if { $next_item_id eq "" } {
	set next_url [dotlrn_community::get_community_url [dotlrn_community::get_community_id]]
    }

    set show_next 1
}