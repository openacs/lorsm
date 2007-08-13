ad_page_contract {
    
    @creation-date 2004-08-07
    @arch-tag: 64f3397b-4558-4298-a995-fc63e472f2a1
    @cvs-id $Id$
} {
    ims_item_id:integer,notnull,optional
    menu_off:integer,notnull,optional
    man_id:integer,notnull
} -properties {
} -validate {
} -errors {
}

set debuglevel 0

ad_set_client_property lorsm debuglevel $debuglevel
#we are in a popup aren't we ?
set menu_off 1

#keepalive and debug would require this
set random [clock seconds]
set ses_renew    [ad_parameter -package_id [ad_acs_kernel_id] SessionRenew security 300]
set ses_timeout  [ad_parameter -package_id [ad_acs_kernel_id] SessionTimeout security 1200]

set cookie [ad_get_cookie ad_session_id]
set track_id [ad_get_client_property lorsm studenttrack]

# Student tracking
set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]
set user_id [ad_conn user_id]

if { ! [info exists ims_item_id] } {
	#since an ims_item_id wasn't provided, we just pick up the first one
	set item_list [lorsm::get_item_list $man_id $user_id]
	set ims_item_id [lindex $item_list 0]
}

ns_log Notice "POPUP.TCL: ims_id is $ims_item_id"
set body_url [export_vars -base "record-view" -url {ims_item_id man_id}]

# return_url
set return_url [dotlrn_community::get_community_url [dotlrn_community::get_community_id]]

