ad_page_contract {

    Main tcl procedures to handle colloquia with java rte applet

    @author Michele Slocovich (michele@sii.it)
    @creation-date 2004-09-27
    @cvs-id $Id$
} {
    functionCalled:notnull
    data:optional
} -properties {
} -validate {
} -errors {
}
ns_log Notice " servlet function called $functionCalled"
if { [info exists data] } {
    ns_log Notice " data: $data"
}

#set the following accordingly to debug or Notice
set basiclevel "Debug"
set tracelevel "Debug"
#tracelevel debug will show messages only at debug level
#tracelevel Notice will show all messages. same goes for basiclevel
#see index.tcl for setting java/javascript debugging by setting debuglevel

#try to circumvent browsers caching strategies
set s [ns_set new]
ns_set put $s "Pragma" "No-Cache"
ns_set put $s "Expires" "0"
ns_set move $s [ns_conn outputheaders]
ns_set move [ns_conn outputheaders] $s

#fetching information
set user_id [ad_conn user_id]
acs_user::get -user_id $user_id -array user
set username $user(username)
ns_log $tracelevel "---------------------------------------"
ns_log $basiclevel "        LMS Rte server START"
ns_log $tracelevel "---------------------------------------"
ns_log $tracelevel "username: $username"
set currentcourse [ad_get_client_property lorsm currentcourse]
ns_log $tracelevel "man_id: $currentcourse"
#this is not used in this proc, so far

set currentpage [ad_get_client_property lorsm ims_id]
set initedonpage [ad_get_client_property lorsm initedonpage]

ns_log $basiclevel "lorsm ims_item_id $currentpage"
ns_log $basiclevel "lorsm initedonpage $initedonpage"

if { ! ($currentpage>0) } {
    ns_log $basiclevel "SCORM missing ims_item_id : $currentpage"
}

set community_id [lors::get_community_id]

if { $user_id == 0 } {
    #http 401 is unauthorized
    ns_return 401 text/plain "Error=101,ErrorDescription=\"Not logged in\""
}

if { $currentcourse == "" } {
    #http 303 is error: but the answer should be found elsewhere
    ns_return 303 text/plain "Error=102,ErrorDescription=\"No current course (how did you get here?)\""
}

if { ! [info exists functionCalled] } {
    #http 400 BAD request: returned as well as when functionCalled is nonsense (see end of switch)
    ns_return 400 text/plain "Error=104,ErrorDescription=\"No function specified\""
}

set currenttrackid [ad_get_client_property lorsm currenttrackid]
set lorsmstudenttrack [ad_get_client_property lorsm studenttrack]

set package_id [ad_conn package_id]

ns_log $basiclevel "SCORM $functionCalled "
ns_log $basiclevel "SCORM tracking (client properties): currenttrackid: $currenttrackid lorsmtrack: $lorsmstudenttrack "

ad_get_user_info
set name $last_name
#seems ADL wants a comma between lastname and christian
append name ", "
append name $first_names

if { $initedonpage != $currentpage } {
    if { $functionCalled != "cmigetcat" } {
        if { $functionCalled != "keepalive" } {
            ns_log warning "SCORM jumping to different courses WITHOUT init!!!"
        } else {
            ns_log warning "SCORM keepalive still alive after LMSFinish"
        }

        #c'e' stato un cambiamento di item
        set lorsmstudenttrack ""
        ad_set_client_property lorsm initedonpage $currentpage
    }
}

switch -regexp $functionCalled {
    null -
    keepalive {
        ns_return 200 text/plain "OK"
        ns_log warning "SCORM Keepalive"

    } cmigetcat {
        ns_log $tracelevel "---------------------------------------"
        ns_log $basiclevel "        LMSInitialise "
        ns_log $tracelevel "---------------------------------------"

        if { $initedonpage != $currentpage } {
            #c'e' stato un cambiamento di item
            set lorsmstudenttrack ""
            ad_set_client_property lorsm initedonpage $currentpage
        }

        if { $lorsmstudenttrack == 0 || $lorsmstudenttrack == ""  } {
                ns_log $basiclevel "SCORM : lorsm student new track "
            #here track id was not set (course is not lors-trackable)
            #we should first try to see if we find an already open track in lorsm.track
            set lorsmstudenttrack [lorsm::track::new \
                                    -user_id $user_id \
                                    -community_id $community_id \
                                    -course_id $currentcourse]

            ad_set_client_property lorsm studenttrack $lorsmstudenttrack
            ns_log $basiclevel "SCORM tracking has in any case created a lorsm_student_tracking track_id: $lorsmstudenttrack"
            if { ! [ db_0or1row isanysuspendedsession {} ] } {
                                        #faccio un nuovo trackid
                                        #and
                                        #   not (
                                        #       cmi.lesson_status = 'completed'
                                        #   or
                                        #       cmi.lesson_status = 'passed'
                                        #   )
                                        #we create a new track which is going to be the new 'master track' for this cmi data set
                set currenttrackid $lorsmstudenttrack
                ns_log $basiclevel "SCORM new track id: $currenttrackid"
            } else {
                set currenttrackid $track_id
                ns_log $basiclevel "SCORM found a lorsm_cmi_core track with a non completed nor passed session."
            }

        } else {
            ns_log $basiclevel "SCORM already has current session (=$lorsmstudenttrack) (istrackable is on): going to check if the session is ok for current item"
            #now we look for the existance of a lorsm.cmi.core track id for this user / course / class which is still not completed
            if { ! [ db_0or1row isanysuspendedsession {} ] } {
                                                    #and
                                                    #        not (
                                                    #                cmi.lesson_status = 'completed'
                                                    #        or
                                                    #                cmi.lesson_status = 'passed'
                                                    #        )
                #the reasoning here is as follows: i had a $lorsmstudenttrack
                #but not track for the course in lorsm_cmi_core. therefore i need to change the
                #"student" track
                set lorsmstudenttrack [lorsm::track::new \
                                        -user_id $user_id \
                                        -community_id $community_id \
                                        -course_id $currentcourse]
                ad_set_client_property lorsm studenttrack $lorsmstudenttrack
                set currenttrackid $lorsmstudenttrack
            } else {
                set currenttrackid $track_id
            }
        }
        #at this stage currenttrackid is the value it should have in lorsm_cmi_core

        if { ![ db_0or1row istherealready {} ] } {
            ns_log $basiclevel "SCORM new RTE lorsm_cmi_core: id $currenttrackid"
            #get initialization data from manifest data already imported
            db_0or1row get_adlcp_student_data {}

            ns_log $basiclevel "SCORM data for lorsm_cmi_student_data is $datafromlms, $maxtimeallowed, $timelimitaction, $masteryscore"
            #
            # lesson_location is the bookmark.
            # lesson_status is initialized to 'not attempted'
            #
            db_dml lmsinitialize {}

            ns_log $basiclevel "SCORM Data inserting into lorsm_student_data $currenttrackid $username $maxtimeallowed"
            db_dml lmsinitialize2 {}

            ad_set_client_property lorsm currenttrackid $currenttrackid
            db_0or1row istherealready {}

            #AURALOG HACK
            #adjust on a per-server basis
            #if { $currentcourse == 6280 } {
            #set student_id "testscorm727"
            #}

            set returndata "cmi.core.student_id=$student_id,cmi.core.student_name=$name,"
            append returndata "cmi.core.lesson_status=$lesson_status,cmi.core.credit=credit,cmi.core.entry=ab-initio,"
            append returndata "cmi.core.lesson_mode=normal,"
            append returndata "cmi.student_preference.language=italian,cmi.comments=$comments,cmi.comments_from_lms=$comments_from_lms"
            append returndata ",cmi.suspend_data=$suspend_data,cmi.launch_data=$launch_data"
            append returndata ",cmi.student_data.max_time_allowed=$maxtimeallowed,cmi.student_data.timelimitaction=$timelimitaction"
            append returndata ",cmi.student_data.mastery_score=$masteryscore"
        } else {
            ns_log $basiclevel "SCORM found RTE lorsm_cmi_core: id $currenttrackid"
            ad_set_client_property lorsm currenttrackid $currenttrackid
            #retrieve data other than core

            if { ![db_0or1row get_adlcp_student_data2 {}] } {
                ns_log Error "SCORM recoverying of student data: not successfull on $currenttrackid -> please check"
                set max_time_allowed ""
                set time_limit_action ""
                set mastery_score ""
            } else {
                ns_log debug "SCORM recoverying of student data: successfull"
            }
            # THIS CHECK is somehow just a previous bug catcher, shouldn't actually be needed
            #               if { [db_resultrows] == 1 } {
            #                       ns_log debug "SCORM recoverying of student data: successfull"
            #                       } else {
            #                       ns_log Error "SCORM recoverying of student data: not successfull on $currenttrackid -> please check"
            #                   }

            ns_log $basiclevel "SCORM retrieved track id in lorsm_cmi_core: $currenttrackid"
            # summing up session time to total_time
            set total_time [expr $total_time + $session_time]
            set total_time_ms [expr $total_time_ms + $session_time_ms]
            set session_time 0
            set session_time_ms 0

            if { $total_time_ms > 100 } {
                set total_time_ms [expr $total_time_ms - 100]
                set total_time [expr $total_time +1 ]
            }
            # erasing session time from server and updating current total time
            set todo "UPDATE lorsm_cmi_core SET total_time = '$total_time"
            append todo "', total_time_ms ='$total_time_ms' "
            #append todo " WHERE track_id=:currenttrackid"
            append todo " WHERE track_id=$currenttrackid"
            db_dml todo $todo

            if { [db_resultrows] == 1 } {
                ns_log debug "SCORM time processing UPDATE: '$todo' successfull"
            } else {
                ns_log Warning "SCORM time processing UPDATE: '$todo' not successfull -> please check"
            }

            set todo "UPDATE lorsm_cmi_core SET session_time = '0"
            append todo "', session_time_ms ='0' "
            #append todo " WHERE track_id=:currenttrackid"
            append todo " WHERE track_id=$currenttrackid"
            db_dml todo $todo
            if { [db_resultrows] == 1 } {
                ns_log debug "SCORM data processing UPDATE: '$todo' successfull"
            } else {
                ns_log Warning "SCORM time processing UPDATE: '$todo' not successfull -> please check"
            }
            #AURALOG HACK
            #adjust on a per-server basis
            #if { $currentcourse == 6280 } {
            #   set student_id "testscorm727"
            #}

            set returndata "cmi.core.student_id=$student_id,cmi.core.student_name=$name,"
            append returndata "cmi.core.credit=$credit,cmi.core.lesson_status=$lesson_status,cmi.core.entry=$entry,"
            append returndata "cmi.core.lesson_mode=normal,cmi.core.lesson_location=$lesson_location,"
            append returndata "cmi.student_preference.language=italian,cmi.comments=$comments,cmi.comments_from_lms=$comments_from_lms"
            append returndata ",cmi.suspend_data=$suspend_data,cmi.launch_data=$launch_data"
            append returndata ",cmi.student_data.max_time_allowed=$max_time_allowed,cmi.student_data.time_limit_action=$time_limit_action"
            append returndata ",cmi.student_data.mastery_score=$mastery_score"
        }

        #treating time from table back to system (lorsm.cmi.time fields are showing just seconds)
        set prefix "0"
        set hours [expr int ($session_time/3600) ]
        set minutes [expr int (($session_time - (3600*$hours)) / 60) ]
        set seconds [expr int (($session_time - (3600*$hours)-$minutes*60)) ]

        if { [ string length $session_time_ms] == 1 } {
            set session_time_ms "$prefix$session_time_ms"
        }

        if { [ string length $hours ] == 1 } {
            set hours "$prefix$hours"
        }

        if { [ string length $minutes] == 1 } {
            set minutes 0$minutes
        }

        if { [ string length $seconds] == 1 } {
            set seconds 0$seconds
        }

        set session_time "$hours:$minutes:$seconds.$session_time_ms"
        #if { ! [empty_string_p $session_time_ms] } { append session_time ".$session_time_ms" }

        set hours [expr int ($total_time/3600) ]
        set minutes [expr int (($total_time - (3600*$hours)) / 60) ]
        set seconds [expr int (($total_time - (3600*$hours)-$minutes*60)) ]

        if { [ string length $total_time_ms] == 1 } {
            set total_time_ms "$prefix$total_time_ms"
        }

        if { [ string length $hours ] == 1 } {
            set hours "$prefix$hours"
        }

        if { [ string length $minutes] == 1 } {
            set minutes 0$minutes
        }

        if { [ string length $seconds] == 1 } {
            set seconds 0$seconds
        }

        set total_time "$hours:$minutes:$seconds.$total_time_ms"
        #if { ! [empty_string_p $total_time_ms] } { append total_time ".$total_time_ms" }
        #appending time fields to return string
        append returndata ",cmi.core.session_time=$session_time,cmi.core.total_time=$total_time"
        ns_log $basiclevel "SCORM initialised, sending data to applet"
        ns_log $tracelevel "$returndata"

        ns_return 200 text/plain "$returndata"

    } cmiputcat* {
        ns_log $tracelevel "---------------------------------------"
        switch $functionCalled {
            cmiputcat {
                ns_log $basiclevel "        LMSCommit"

            } cmiputcatONFINISH {
                ns_log $basiclevel "        LMSFinish"
            }
        }
        ns_log $tracelevel "---------------------------------------"
        ns_log $tracelevel "received data $data from applet: processing. "
        ns_log $tracelevel "Reference cmi track is $currenttrackid, while lorsmstudenttrack is: $lorsmstudenttrack"
        set preparselist [lrange [ split $data "," ] 1 end]
        set lista [list]
        set value ""
        #here we build a list of request=value. we must do some pattern matching
        foreach couple $preparselist {
            if { [ regexp ^cmi\.* $couple ] } {
                if { ! [empty_string_p $value]  } {
                    set value [concat [lindex $lista end],$value]
                    ns_log debug "SCORM PARSER ending recomposing $value "
                    set lista [lreplace $lista end end $value]
                    set value ""
                } else {
                    ns_log debug "SCORM PARSER full couple $couple "
                    lappend lista $couple
                }
            } else {
                ns_log debug "SCORM PARSER partial couple $couple "
                set value [concat $value,$couple]
                ns_log debug "SCORM PARSER partial couple $couple "
            }
        }

        if { ! [empty_string_p $value] } {
            set value [concat [lindex $lista end],$value]
            ns_log debug "SCORM PARSER ending recomposing $value "
            set lista [lreplace $lista end end $value]
            set value ""
        }

        #end splitting list from applet
        foreach couple $lista {
            set all ""
            set request ""
            set value ""
            #create list named item to contain request and value
            regexp \(\[^=\]+\)=\(\.*\)$ $couple all request  value
            ns_log debug "SCORM request from applet is $all that is $request to $value"

            if { [ string length $value ] == 0 } {
                ns_log debug "SCORM EMPTY settings : '$request' received and empty -> won't skip"
            }

            set table [lindex [split $request .] 1]
            set column [string trim [lindex [split $request .] 2]]
            switch $table {
                null -
                "" {
                    ns_log debug "SCORM EMPTY TABLENAME : '$table', '$column'  not implemented -> not treating this applet request"

                } core  {
                    if { [ string compare "total_time" $column ] } {
                        # string compare returns 0 for equal, -1 or +1 in other cases
                        # time fields preprocessing

                        if { [ string first "time" $column ] >0  } {
                            # conversion of HHHH:MM:SS.SS
                            # removing leading zeros:
                            # 'regsub {^0*((1-90-9*)|0)$} $x {\1} x'
                            regsub {^0} [lindex [split $value :] 0] "" hours
                            regsub {^0} [lindex [split $value :] 1] "" minutes
                            regsub {^0} [lindex [split $value :] 2] "" seconds
                            regsub {^0} [lindex [split $value .] 1] "" msecs
                            if { [empty_string_p $hours] } {
                                set hours 0
                            }

                            if { [empty_string_p $minutes] } {
                                set minutes 0
                            }

                            if { [empty_string_p $seconds] } {
                                set seconds 0
                            }

                            if { [empty_string_p $msecs] } {
                                set msecs 0
                            }

                            set column_ms $column
                            append column_ms "_ms"
                            set todo "UPDATE lorsm_cmi_$table SET $column_ms = '"
                            append todo $msecs
                            append todo "' WHERE track_id=$currenttrackid"
                            #append todo "' WHERE track_id=:currenttrackid"

                            db_dml todo $todo
                            if { [db_resultrows] == 1 } {
                                ns_log debug "SCORM data msecs processing UPDATE: '$todo' successfull"
                            } else {
                                ns_log Warning "SCORM data msecs processing UPDATE: '$todo' not successfull -> please check"
                            }

                            #set minutes [string trim [lindex [split $value :] 1]]
                            #set seconds [string trim [lindex [split $value :] 2]]
                            set value [expr int (( $hours*60 + $minutes ) * 60 + $seconds) ]
                        }

                        set todo "UPDATE lorsm_cmi_$table SET $column = '"
                        append todo $value
                        append todo "' WHERE track_id=$currenttrackid"
                        #append todo "' WHERE track_id=:currenttrackid"

                        db_dml todo $todo
                        if { [db_resultrows] == 1 } {
                            ns_log debug "SCORM data processing UPDATE: '$todo' successfull"
                        } else {
                            ns_log Warning "SCORM data processing UPDATE: '$todo' not successfull -> please check"
                        }

                        #lesson_status postprocessing
                        if { ! [ string compare "lesson_status" $column ] } {
                            ns_log notice "LESSON STATUS set to $value, cascading down the tree"
                            #lesson status can be:
                            #Passed
                            #Completed
                            #Browsed
                            #Failed
                            #Not attempted
                            #Incomplete
                            ns_log debug "SCORM servlet: lesson_status postprocessing"
                            lorsm::delivery::scorm::check_parents -ims_item_id $currentpage
                        }
                    }

                } default {
                    ns_log Warning "SCORM table: '$table', '$column' not implemented -> not treating this applet request"
                }
            }
        }

        switch $functionCalled {
            cmiputcat {
                #We try setting track exit so that we keep some exit time
                #even if user closes the course without passing by FINISH
                if { $lorsmstudenttrack == "" || $lorsmstudenttrack == 0 } {
                    lorsm::track::exit -track_id $currenttrackid
                } else {
                    #speficic for courses for which istrackable is on
                    lorsm::track::exit -track_id $lorsmstudenttrack
                }

                ns_return 200 text/plain "OK"
                ns_log $basiclevel "SCORM post LMSCommit (trackid=$currenttrackid)"

            } cmiputcatONFINISH {
                set lorsmstudenttrack [ad_get_client_property lorsm studenttrack]
                ad_set_client_property lorsm studenttrack ""
                ad_set_client_property lorsm currenttrackid ""
                ad_set_client_property lorsm initedonpage ""

                if { $lorsmstudenttrack == "" || $lorsmstudenttrack == 0 } {
                    lorsm::track::exit -track_id $currenttrackid

                } else {
                    #speficic for courses for which istrackable is on
                    lorsm::track::exit -track_id $lorsmstudenttrack
                }
                ns_return 200 text/plain "OK"
                ns_log $basiclevel "SCORM post LMSFinish (trackid=$currenttrackid) sent ok to applet"
            }
        }

    } default {
        #returning a BAD REQUEST and not a GATEWAY ERROR !!!
        ns_return 400 text/plain "Error=103,ErrorDescription=\"No functionCalled meaningful value provided\""
    }
}
ns_log $tracelevel "---------------------------------------"
ns_log $basiclevel "        LMS Rte server END"
ns_log $tracelevel "---------------------------------------"
