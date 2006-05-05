ad_page_contract {
    
    @creation-date 2004-08-07
    @arch-tag: 64f3397b-4558-4298-a995-fc63e472f2a1
    @cvs-id $Id$
} {
    return_url:notnull
    menu_off:integer,notnull,optional
    man_id:integer,notnull
    ims_id:integer,notnull,optional
} -properties {
} -validate {
} -errors {
}

set debuglevel [ad_get_client_property lorsm debuglevel]
if {$debuglevel > 0} {
    set app_width 150
    set app_height 150
} else {
    set app_width 0
    set app_height 0
}
set random [clock seconds]
set ses_renew    [ad_parameter -package_id [ad_acs_kernel_id] SessionRenew security 300]
set ses_timeout  [ad_parameter -package_id [ad_acs_kernel_id] SessionTimeout security 1200]


set cookie [ad_get_cookie ad_session_id]
set track_id [ad_get_client_property lorsm studenttrack]

if { ! [info exists menu_off] } {
	set menu_off 0
}

# Student tracking
set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]
set user_id [ad_conn user_id]


set item_id [ad_get_client_property lorsm ims_id]

if { [info exists ims_id] } {
    ns_log Notice "APPLET.TCL: ims_id is $ims_id"
    set body_url [export_vars -base "record-view" -url {item_id man_id}]
} else {
    if { ! [empty_string_p $item_id] } {
    ns_log Notice "APPLET.TCL: item_id is $item_id"
    set ims_id $item_id
    set body_url [export_vars -base "record-view" -url {item_id man_id}]
    }
}


