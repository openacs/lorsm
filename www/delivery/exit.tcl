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

#set the following accordingly
set level "debug"

set track_id [ad_get_client_property lorsm currenttrackid]
set lorsmstudenttrack [ad_get_client_property lorsm studenttrack]

ns_log $level "EXIT track_id $track_id"
ns_log $level "SCORM lorsmstudenttrack $lorsmstudenttrack"

if { ! [empty_string_p $lorsmstudenttrack] } {
    if { $lorsmstudenttrack == 0 } {
        lorsm::track::exit -track_id $track_id
    } else {
        #speficic for courses for which istrackable is on
        lorsm::track::exit -track_id $lorsmstudenttrack
    }

    ns_log $level "SCORM exiting a scorm course which didnt'actually FINISH"
} else {
    ns_log $level "SCORM exiting a scorm course which never INITED"
}

#unset the CLIENT properties
ad_set_client_property lorsm currenttrackid ""
ad_set_client_property lorsm studenttrack ""
if { $track_id == 0 || $track_id == "" } {
    ns_log $level   "delivery/exit leaving non rte-inited
                    (or better a rte-finished) course"
} else {
    ns_log $level   "delivery/exit leaving course which had been
                    rte-inited but NOT FINISHED (user forcing exit before
                    time) (lorsm_cmi_core.track_id=$track_id)"
}
if { $lorsmstudenttrack == 0 || $lorsmstudenttrack == "" } {
    ns_log $level "delivery/exit leaving non istrackable course"
} else {
    ns_log $level   "delivery/exit leaving course which was either
                    istrackable or rte-inited
                    (lorsm_student_track.track_id=$lorsmstudenttrack"
}

# redirects
ns_log $level "delivery/exit $return_url"
ad_returnredirect $return_url
