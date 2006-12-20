# packages/lorsm/www/delivery4/index.tcl

ad_page_contract {
    
    New index file using new tree menu
    
    @author Roel Canicula (roelmc@info.com.ph)
    @creation-date 2004-08-07
    @arch-tag: 64f3397b-4558-4298-a995-fc63e472f2a1
    @cvs-id $Id$
} {
    man_id:notnull
    ims_id:notnull,optional
} -properties {
} -validate {
    man_id_exist {
	ns_log Debug "lorsm delivery-no-index man_id $man_id"
	#ad_complain
    }
} -errors {
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]

ns_log Debug "lorsm delivery-no-index man_id $man_id"

if { [info exists ims_id] } {
    set item_id $ims_id
    
    set body_url [export_vars -base "record-view" -url {item_id man_id}]
}

# Get the course name
if {[db_0or1row manifest "" ]} {
    
    # Course Name
    if {[empty_string_p $course_name]} {
	set course_name "[_ lorsm.No_Course_Name]"
    } 
} else {
    set course_name "[_ lorsm.No_Course_Name]"
}

db_0or1row get_last_viewed {}

set all_items [db_list get_total_items {}]

set total_item_count [llength $all_items]
set viewed_items [db_list get_viewed_items ""]
set viewed_item_count [llength $viewed_items]
set viewed_percent [lc_numeric [expr [expr $viewed_item_count * 1.00] / $total_item_count * 100] "%.2f"]

#Get times viewed

set viewed_times [db_string select_viewed_times ""]

ns_log Debug "lorsm: delivery-no-index man_id $man_id"

# Get the course name
if {[db_0or1row manifest ""]} {
    
    # Course Name
    if {[empty_string_p $course_name]} {
	set course_name "[_ lorsm.No_Course_Name]"
    } 
} else {
    set course_name "[_ lorsm.No_Course_Name]"
}

if { !$viewed_item_count } {
	set first_item_id [lindex [lorsm::get_item_list $man_id $user_id] 0]
}
