# packages/lorsm/www/delivery4/index.tcl

ad_page_contract {
    
    New index file using new tree menu
    
    @author Roel Canicula (roelmc@info.com.ph)
    @creation-date 2004-08-07
    @arch-tag: 64f3397b-4558-4298-a995-fc63e472f2a1
    @cvs-id $Id$
} {
    man_id:integer,notnull
    ims_id:integer,notnull,optional
} -properties {
} -validate {
} -errors {
}

if { [info exists ims_id] } {
    set item_id $ims_id
    
    set body_url [export_vars -base "record-view" -url {item_id man_id}]
}

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

# Student tracking
set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]
set user_id [ad_conn user_id]

if {[lorsm::track::istrackable -course_id $man_id -package_id $package_id]} {
    
    set track_id [lorsm::track::new \
		      -user_id $user_id \
		      -community_id $community_id \
		      -course_id $man_id]
} else {
    set track_id 0
}
