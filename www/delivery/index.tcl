# packages/lorsm/www/delivery4/index.tcl

ad_page_contract {
    
    New index file using new tree menu
    
    @author Roel Canicula (roelmc@info.com.ph)
    @creation-date 2004-08-07
    @arch-tag: 64f3397b-4558-4298-a995-fc63e472f2a1
    @cvs-id $Id$
} {
    man_id:integer,notnull
    menu_off:integer,notnull,optional
    item_id:integer,notnull,optional
    ims_id:integer,notnull,optional
} -properties {
} -validate {
} -errors {
}


set debuglevel 0
set menu_type "menu-mk"
ad_set_client_property lorsm debuglevel $debuglevel
ad_set_client_property lorsm menu_type $menu_type

set ses_renew    [ad_parameter -package_id [ad_acs_kernel_id] SessionRenew security 300]


if { ! [info exists menu_off] } {
	set menu_off 0
}

set user_id [ad_conn user_id]

if { [info exists item_id] } {
    ad_set_client_property lorsm ims_id $item_id
    if { ! [info exists ims_id] } {
	set ims_id $item_id
	}
} else {
	if { $menu_off == 0 } {
    ad_set_client_property lorsm ims_id ""
    ns_log notice "UNSETTING LORSM IMS_ID '[ad_conn url]'"
	} else {
	#given menu_off without ims_id, i have to provide a default one!
	#since an ims_item_id wasn't provided, we just pick up the first one
	set item_list [lorsm::get_item_list $man_id $user_id]
	set ims_id [lindex $item_list 0]
    ad_set_client_property lorsm ims_id $ims_id
	}
}

if { [info exists ims_id] } {
    set item_id $ims_id
    ad_set_client_property lorsm ims_id $ims_id    
#    ns_log notice "SETTING LORSM IMS_ID = '${ims_id}' '[ad_conn url]'"
    set body_url [export_vars -base "record-view" -url {item_id man_id}]
}



# Get the course name
if {[db_0or1row manifest "
    select 
         cp.course_name,
	   cp.fs_package_id,
           isscorm,
           pf.folder_name,
           pf.format_name,
		case
			when upper(scorm_type) = 'SCO' then 'delivery-scorm'
			else 'delivery'
        end as deliverymethod
    from
           ims_cp_manifests cp  left join (select man_id, max(scorm_type) as scorm_type from ims_cp_resources group by man_id ) as cpr using (man_id) ,
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

ns_log warning "\$isscorm=$isscorm while delivery method has to be = $deliverymethod"

if {$isscorm} {
    set folder_name "delivery-scorm"
} else {
	# workaround for when isscorm is set to inconsisten value
	# (who sets it ?)
	if {$deliverymethod=="delivery-scorm"} {
		set folder_name delivery-scorm
	}
}

set return_url [dotlrn_community::get_community_url [dotlrn_community::get_community_id]]

# Student tracking
set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]
ad_set_client_property lorsm currentcourse $man_id


set enabled_p [db_string enabled_p "select isenabled from ims_cp_manifest_class where man_id=:man_id and community_id=:community_id" -default "f"]
set item_list [lorsm::get_item_list $man_id $user_id]

if {$enabled_p} {
	permission::require_permission \
		-party_id $user_id \
	        -object_id $man_id \
                -privilege read
} else {
	permission::require_permission \
		-party_id $user_id \
	        -object_id $man_id \
                -privilege admin
}


set start_page [lorsm::get_custom_page_ims_item_id -man_id $man_id -type start]

if {$start_page eq "" && [lorsm::track::istrackable -course_id $man_id -package_id $package_id]} {
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

#db_1row get_format "select folder_name, isscorm from lorsm_course_presentation_formats f, ims_cp_manifests m where f.format_id=m.course_presentation_format and m.man_id=:man_id"
#if {$isscorm} {
#    set folder_name delivery-scorm
#}

ad_set_client_property lorsm deliverymethod $folder_name

ns_log debug "delivery/index.tcl returning with folder_name $folder_name"
