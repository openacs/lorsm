# packages/lorsm/www/delivery/index.tcl

ad_page_contract {
    
    Course Delivery Table of Content
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-09
    @arch-tag 553390f0-450e-48db-99f0-c5dcb17978b8
    @cvs-id $Id$
} {
    man_id:integer,notnull  
    ims_id:integer,notnull,optional
    track_id:integer,notnull
} -properties {
} -validate {
} -errors {
}

# return_url
set return_url [dotlrn_community::get_community_url [dotlrn_community::get_community_id]]
