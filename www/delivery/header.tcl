# packages/lorsm/www/delivery/header.tcl

ad_page_contract {
    
    Course Delivery Header
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-09
    @arch-tag 3e231cd4-395e-428e-a3ba-ca52cf73a0dd
    @cvs-id $Id$
} {
    course_name:notnull
} -properties {
} -validate {
} -errors {
}

set back_to_community [dotlrn_community::get_community_url [dotlrn_community::get_community_id]]