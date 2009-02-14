# packages/lorsm/www/delivery/delivery-context-bar.tcl

ad_page_contract {

} {
    {__include ""}
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

set community_id [lors::get_community_id]
set user_id [ad_conn user_id]
set lorsm_url [ad_conn package_url]delivery

# Student tracking
set package_id [ad_conn package_id]
#if {[lorsm::track::istrackable -course_id $man_id -package_id $package_id]} {

#    set track_id [lorsm::track::new \
\#            -user_id $user_id \
\#            -community_id $community_id \
\#            -course_id $man_id]
#} else {
    set track_id 0
#}

# return_url
set return_url [lors::get_community_url]

set item_list [lorsm::get_item_list $man_id $user_id]

set last_item_viewed [db_string select_last_item_viewed {} -default ""]

set first_item_id [lindex $item_list 0]
set first_item_url "<a href=\"[export_vars \
                        -base "${lorsm_url}/record-view" \
                        -url {{item_id $first_item_id} man_id}]\">
                                <img src=\"${lorsm_url}/Images/home.png\"
                                border=\"0\"
                                title=\"home\"
                                onclick=\"window.location.reload()\"></a>"

if {$item_id eq ""} {
    set item_id $first_item_id
    ad_returnredirect [export_vars -base ${lorsm_url}/record-view {man_id item_id}]
    ad_script_abort
}

#set curr_index [expr [lsearch -exact $item_list $last_item_viewed]]
set curr_index [expr [lsearch -exact $item_list $item_id]]
if {$curr_index < 1} {
    set curr_index 0
}

set prev_item_id [lindex $item_list [expr $curr_index - 1]]
set next_item_id [lindex $item_list [expr $curr_index + 1]]
set prev_url "<a href=\"[export_vars \
                -base "${lorsm_url}/record-view" \
                -url {{item_id $prev_item_id} man_id}]\">
                        <img src=\"${lorsm_url}/Images/prev.png\"
                        border=\"0\" title=\"next\"
                        onclick=\"window.location.reload()\"></a>"

set next_url [export_vars \
                -base "${lorsm_url}/record-view" \
                -url {{item_id $next_item_id} man_id}]

set prev_title [db_string get_title_prev {} -default ""]

set next_title [db_string get_title_next {} -default ""]

set current_title [db_string get_title_current {} -default ""]

set progress_list [template::util::number_list [llength $item_list] 1]
set progress_index [expr {$curr_index + 1}]

if {[string match "*assessment*" $__include]} {
    set show_next 0
} else {
    show_next 1
}
