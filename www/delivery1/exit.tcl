# packages/lorsm/www/delivery/exit.tcl

ad_page_contract {
    
    Student tracking exit
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-05-25
    @arch-tag 04aa013e-2a53-45eb-825d-d576ea35cd14
    @cvs-id $Id$
} {
    track_id:integer
    return_url
} -properties {
} -validate {
} -errors {
}

# stamps the time when leaving the delivery environment

if {$track_id != 0} {
    lorsm::track::exit -track_id $track_id
}

# redirects
ad_returnredirect $return_url
