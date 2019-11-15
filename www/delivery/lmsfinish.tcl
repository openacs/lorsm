# packages/lorsm/www/delivery-scorm/lmsfinish.tcl

ad_page_contract {

    called if an user is switching between items of the same manifest,
    WITHOUT the content having previously called LMSFinish

    @author Michele Slocovich ()
    @creation-date 2004-07-04
} {
    item_id:optional,integer,notnull
    man_id:integer,notnull
    initedonpage:integer,notnull
} -properties {
} -validate {
} -errors {
}

if { ! [info exists item_id] } {
    set item_id 0
}

#this should automatically happen. nevertheless we put it here
#ad_set_client_property lorsm studenttrack ""
#ad_set_client_property lorsm currenttrackid ""
#ad_set_client_property lorsm initedonpage ""

