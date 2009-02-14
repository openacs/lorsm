# packages/lorsm/www/delivery/header.tcl

ad_page_contract {
    
    Course Delivery Header
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-09
    @arch-tag 3e231cd4-395e-428e-a3ba-ca52cf73a0dd
    @cvs-id $Id$
} {
    course_name:notnull
    track_id:integer
} -properties {
} -validate {
} -errors {
}

set return_url [lors::get_community_url]


# urls
set exit_url "exit?[export_vars {return_url track_id}]"
set logout_url "exit?return_url=/register/logout&[export_vars track_id]"
