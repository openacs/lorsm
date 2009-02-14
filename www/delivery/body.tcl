# packages/lorsm/www/delivery/body.tcl

ad_page_contract {

    Course Delivery Body

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-09
    @arch-tag a20dffe3-6d54-4ece-858c-4529e82c163b
    @cvs-id $Id$
} {
    man_id:notnull
    lmsfinish:optional
} -properties {
} -validate {
} -errors {
}

set user_id [ad_conn user_id]
set community_id [lors::get_community_id]

if { ! [info exists lmsfinish] } {
        set lmsfinish 0
}

#SCORM for finish
set initedonpage [ad_get_client_property lorsm initedonpage]

if { $initedonpage!=0 && $initedonpage!=""  } {
    if { $lmsfinish > 0 } {
            ns_log warning  "SCORM : back to record view after lms finish,
                            but it hasn't worked!"
            ns_log warning "SCORM : resetting all visiting parameters."
            ad_set_client_property lorsm studenttrack 0
            ad_set_client_property lorsm studenttrack ""
            ad_set_client_property lorsm currenttrackid ""
            ad_set_client_property lorsm initedonpage ""
        } else {
            ad_set_client_property lorsm studenttrack 0
            ns_log warning "SCORM : new content item with still open course ???"
            ns_log warning  "SCORM : we call for LMSFinish in place of
                            the content!!!!!!???"
            ad_returnredirect [export_vars -base lmsfinish {man_id initedonpage} ]
    }
}


db_0or1row get_last_viewed {}

set all_items [db_list get_total_items {}]

set total_item_count [llength $all_items]
set viewed_items [db_list get_viewed_items {}]

set viewed_item_count [llength $viewed_items]
set viewed_percent [lc_numeric \
                        [expr \
                            [expr $viewed_item_count * 1.00] / \
                            $total_item_count * 100] "%.2f"]

#Get times viewed
set viewed_times [db_string select_viewed_times {}]

# Get the course name
if {[db_0or1row manifest {}]} {

    # Course Name
    if {[empty_string_p $course_name]} {
        set course_name "[_ lorsm.No_Course_Name]"
    }
} else {
    set course_name "[_ lorsm.No_Course_Name]"
}
