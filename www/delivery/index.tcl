# packages/lorsm/www/delivery4/index.tcl

ad_page_contract {
    
    New index file using new tree menu
    
    @author Roel Canicula (roelmc@info.com.ph)
    @creation-date 2004-08-07
    @arch-tag: 64f3397b-4558-4298-a995-fc63e472f2a1
    @cvs-id $Id$
} {
    menu_off:integer,notnull,optional
    man_id:integer,notnull
    item_id:integer,notnull,optional
    ims_id:integer,notnull,optional
} -properties {
} -validate {
} -errors {
}

set debuglevel 0
ad_set_client_property lorsm debuglevel $debuglevel

set ses_renew    [ad_parameter -package_id [ad_acs_kernel_id] SessionRenew security 300]

if { ! [info exists menu_off] } {
	set menu_off 0
}

if { [info exists item_id] } {
    ad_set_client_property lorsm ims_id $item_id
    if { ! [info exists ims_id] } {
	set ims_id $item_id
	}
} else {
    ad_set_client_property lorsm ims_id ""
    ns_log notice "UNSETTING LORSM IMS_ID '[ad_conn url]'"
}

if { [info exists ims_id] } {
    set item_id $ims_id
    ad_set_client_property lorsm ims_id $ims_id    
    ns_log notice "SETTING LORSM IMS_ID = '${ims_id}' '[ad_conn url]'"
    set body_url [export_vars -base "record-view" -url {item_id man_id}]
}

# Get the course name
if {[db_0or1row manifest "
    select 
         cp.course_name,
	   cp.fs_package_id,
           isscorm,
           pf.folder_name,
           pf.format_name
    from
           ims_cp_manifests cp,
           lorsm_course_presentation_formats pf
    where 
	   cp.man_id = :man_id
           and  cp.parent_man_id = 0
           and cp.course_presentation_format = pf.format_id "]} {
    
    # Course Name
    if {[empty_string_p $course_name]} {
	set course_name "No Course Name"
    } 
} else {
    set course_name "No Course Name"
}
if {$isscorm} {
    set folder_name "delivery-scorm"
}
set return_url [dotlrn_community::get_community_url [dotlrn_community::get_community_id]]


# Student tracking
set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]
set user_id [ad_conn user_id]
ad_set_client_property lorsm currentcourse $man_id


if {[lorsm::track::istrackable -course_id $man_id -package_id $package_id]} {
    set track_id [lorsm::track::new \
		      -user_id $user_id \
		      -community_id $community_id \
		      -course_id $man_id]
    ad_set_client_property lorsm studenttrack $track_id
} else {
    set track_id 0
    ad_set_client_property lorsm studenttrack 0
}


## FIXME

db_1row get_format "select folder_name, isscorm from lorsm_course_presentation_formats f, ims_cp_manifests m where f.format_id=m.course_presentation_format and m.man_id=:man_id"
if {$isscorm} {
    set folder_name delivery-scorm
}
