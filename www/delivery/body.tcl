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
set community_id [dotlrn_community::get_community_id]

if { ! [info exists lmsfinish] } {
        set lmsfinish 0
}

#SCORM for finish
set initedonpage [ad_get_client_property lorsm initedonpage]

if { $initedonpage!=0 && $initedonpage!=""  } {
	if { $lmsfinish > 0 } {
			ns_log warning "SCORM : back to record view after lms finish, but it hasn't worked!"
			ns_log warning "SCORM : resetting all visiting parameters."
			ad_set_client_property lorsm studenttrack 0
 			ad_set_client_property lorsm studenttrack ""
			ad_set_client_property lorsm currenttrackid ""
			ad_set_client_property lorsm initedonpage ""
		} else {
			ad_set_client_property lorsm studenttrack 0
 			ns_log warning "SCORM : new content item with still open course ???"
  			ns_log warning "SCORM : we call for LMSFinish in place of the content!!!!!!???"
			ad_returnredirect [export_vars -base lmsfinish {man_id initedonpage} ]
	}
}


db_0or1row get_last_viewed {
    select ims_item_id as imsitem_id, coalesce(acs_object__name(object_id),'Item '||object_id) as last_page_viewed
    from views v,
         ims_cp_items i,
         ims_cp_organizations o
    where v.viewer_id = :user_id
          and v.object_id = i.ims_item_id
          and i.org_id = o.org_id
          and o.man_id = :man_id
    order by v.last_viewed desc
    limit 1
}

set all_items [db_list get_total_items {
    select i.ims_item_id
    from ims_cp_items i,
    ims_cp_organizations o
    where o.man_id = :man_id
    and i.org_id = o.org_id   
}]
set total_item_count [llength $all_items]
set viewed_items [db_list get_viewed_items "
            select v.object_id
              from views v
             where v.viewer_id = :user_id
	     and v.object_id in ([join $all_items ,])
        "]
set viewed_item_count [llength $viewed_items]
set viewed_percent [lc_numeric [expr [expr $viewed_item_count * 1.00] / $total_item_count * 100] "%.2f"]

#Get times viewed

set viewed_times [db_string select_viewed_times "
             select count(*) 
             from lorsm_student_track 
             where community_id = :community_id
             and course_id = :man_id
             and user_id = :user_id "]

# Get the course name
if {[db_0or1row manifest "
    select 
           cp.course_name,
	   cp.fs_package_id
    from
           ims_cp_manifests cp
    where 
	   cp.man_id = :man_id
           and  cp.parent_man_id = 0"]} {
    
    # Course Name
    if {[empty_string_p $course_name]} {
	set course_name "[_ lorsm.No_Course_Name]"
    } 
} else {
    set course_name "[_ lorsm.No_Course_Name]"
}