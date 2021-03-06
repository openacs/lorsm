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

set debuglevel [ ad_get_client_property lorsm debuglevel ]
set menu_off 1

if { [info exists item_id] } {
    ad_set_client_property lorsm ims_id $item_id
    if { ! [info exists ims_id] } {
        set ims_id $item_id
    }
}

if { [info exists ims_id] } {
    set item_id $ims_id
    ad_set_client_property lorsm ims_id $ims_id
    set body_url [export_vars -base "record-view" -url {item_id man_id}]
}

# Get the course name
if {[db_0or1row manifest {}]} {
    # Course Name
    if {[empty_string_p $course_name]} {
        set course_name "No Course Name"
    }
} else {
    set course_name "No Course Name"
}

# Student tracking
set package_id [ad_conn package_id]
set community_id [lors::get_community_id]
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
