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

#set the following accordingly to Debug, Warning or Notice
set level "Debug"

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
set currentcourse [ad_get_client_property lorsm currentcourse]
#this is not used in this proc, so far

set currentpage [ad_get_client_property lorsm ims_id]
# currentcourse is the package, currentpage is the item
# this is not working consistently set whichpage [lorsm::get_ims_item_id]
ns_log Notice "delivery-scorm::servlet username $username , currentcourse $currentcourse , currentpage $currentpage"

if { ! ($currentpage>0) } {
    ns_log warning "lorsm - ERROR SESSION lorsm ims_id returned is $currentpage"
    set currentpage 0
}
ns_log $level "lorsm - currentpage $currentpage "

ns_log $level "lorsm - beginning transaction for user: $user_id course: $currentcourse page (ims_item_id): $currentpage"

if { $user_id == 0 } {
    #_return 303 text/plain "101"
    ns_return 504 text/plain "Error=101,ErrorDescription=\"Not logged in\""
}
if { $currentcourse == "" } {
    ns_return 504 text/plain "Error=102,ErrorDescription=\"No current course (how did you get here?)\""
}
if { ! [info exists functionCalled] } {
    ns_return 504 text/plain "Error=104,ErrorDescription=\"No function specified\""
}

set currenttrackid [ad_get_client_property lorsm currenttrackid]
set lorsmstudenttrack [ad_get_client_property lorsm studenttrack]

set community_id [lors::get_community_id]
set package_id [ad_conn package_id]

ns_log $level "Applet beginning with parameters current: $currenttrackid lorsm - $lorsmstudenttrack community: $community_id"

ad_get_user_info
set name $last_name
#seems ADL wants a comma between lastname and christian
append name ", "
append name $first_names

switch -regexp $functionCalled {
	null -
	cmigetcat
    {
	ns_log $level "lorsm - serving LMSInitialize from applet"
	if { $lorsmstudenttrack == 0 || $lorsmstudenttrack == ""  } {
	    ns_log $level "lorsm - called with no track id for current session (istrackable is off): try to fetch one"
	    #here track id was not set (course is not lors-trackable)
	    #we should first try to see if we find an already open track in lorsm.track
	    if { ! [ db_0or1row isanysuspendedsession "
						select lorsm.track_id as track_id from lorsm_student_track lorsm, lorsm_cmi_core cmi
						where 
							lorsm.user_id = $user_id
						and
							lorsm.community_id = $community_id
						and
							lorsm.course_id = $currentcourse
						and
							lorsm.track_id = cmi.track_id 
						and 
							not (
								cmi.lesson_status = 'completed'
							or		
								cmi.lesson_status = 'passed'
							)
						and 	
							cmi.man_id = $currentcourse
						and 	
							cmi.item_id = $currentpage
						order by 
							lorsm.track_id desc
						limit 1
								" ] } { #faccio un nuovo trackid
		#we create a new track which is going to be the new 'master track' for this cmi data set
		set currenttrackid [lorsm::track::new \
					-user_id $user_id \
					-community_id $community_id \
					-course_id $currentcourse]
		ad_set_client_property lorsm studenttrack $currenttrackid
		ns_log $level "lorsm - Tracking has generated a lorsm_student_track new track id: $currenttrackid"
	    } else {
		ns_log $level "lorsm - Tracking has not found a lorsm_cmi_core track with a non completed nor passed session."
		set currenttrackid $track_id
		set lorsmstudenttrack [lorsm::track::new \
					   -user_id $user_id \
					   -community_id $community_id \
					   -course_id $currentcourse]
		ns_log $level "lorsm - Tracking has in any case created a lorsm_student_tracking track_id: $lorsmstudenttrack"
		ad_set_client_property lorsm studenttrack $lorsmstudenttrack
	    }
	} else {
	    ns_log $level "lorsm - called with track id for current session (=$lorsmstudenttrack) (istrackable is on): going to check whether to create a lorsm_cmi_core new track"
	    #now we look for the existence of a lorsm.cmi.core track id for this user / course / class which is still not completed 
	    if { ! [ db_0or1row isanysuspendedsession "
                                                select lorsm.track_id as track_id from lorsm_student_track lorsm, lorsm_cmi_core cmi
                                                where
                                                        lorsm.user_id = $user_id
                                                and
                                                        lorsm.community_id = $community_id
                                                and
                                                        lorsm.course_id = $currentcourse
                                                and
                                                        lorsm.track_id = cmi.track_id
                                                and
                                                        not (
                                                                cmi.lesson_status = 'completed'
                                                        or
                                                                cmi.lesson_status = 'passed'
                                                        )
						and 	
							cmi.man_id = $currentcourse
						and 	
							cmi.item_id = $currentpage
                                                order by
                                                        lorsm.track_id desc
                                                limit 1
                                                                " ] } { 
		set currenttrackid $lorsmstudenttrack
	    } else {
		set currenttrackid $track_id
	    }
	}
	#in any case at this stage track_id is currentely set to the value it should have in lorsm_cmi_core (disregarding if we have still to create it)

	if { ! [ db_0or1row istherealready "select * from lorsm_cmi_core where track_id = :currenttrackid "]} {
	    ns_log $level "lorsm - Inserting track id in lorsm_cmi_core: value will be $currenttrackid"
	    ns_log $level "lorsm - I now have a track_id=$currenttrackid but i cannot find no corresponding record in lorsm_cmi_core "
	    #get initialization data from manifest data already imported
	    if { [ db_0or1row get_adlcp_student_data { select datafromlms,maxtimeallowed,timelimitaction,masteryscore from ims_cp_items where ims_item_id=:currentpage; } ] } {
		ns_log $level "lorsm - data for lorsm_cmi_student_data is $datafromlms, $maxtimeallowed, $timelimitaction, $masteryscore"
	    } else {
		ns_log warning "lorsm - COULD NOT RETRIEVE DATA FROM LORSM_CMI_STUDENT_DATA from IMS_CP_ITEMS possibily ims_item_id should be $currentpage"
	    }

	    #
	    db_dml lmsinitialize { insert into lorsm_cmi_core(track_id,man_id,item_id,student_id,student_name,lesson_location,
							      lesson_status,
							      launch_data,
							      comments,comments_from_lms, session_time, total_time, time_stamp)
		values(:currenttrackid,:currentcourse,:currentpage,:username,:name,:currentcourse,
		       'not attempted',
		       :datafromlms,
		       '','commenti da lors',0,0,CURRENT_TIMESTAMP) }
	    db_dml lmsinitialize { insert into lorsm_cmi_student_data(track_id,student_id,max_time_allowed,time_limit_action,mastery_score)
		values(:currenttrackid,:username,:maxtimeallowed,:timelimitaction,:masteryscore)
	    }
	    ad_set_client_property lorsm currenttrackid $currenttrackid
	    db_1row istherealready "select * from lorsm_cmi_core where track_id = :currenttrackid"

	    #AURALOG HACK
	    #adjust on a per-server basis
	    if { $currentcourse == 11287 } {
		set student_id "testscorm711"
	    }
	    set returndata "cmi.core.student_id=$student_id,cmi.core.student_name=$name,"
	    append returndata "cmi.core.lesson_status=$lesson_status,cmi.core.credit=credit,cmi.core.entry=ab-initio,"
	    append returndata "cmi.core.lesson_mode=normal,"
	    append returndata "cmi.student_preference.language=italian,cmi.comments=$comments,cmi.comments_from_lms=$comments_from_lms"
	    append returndata ",cmi.suspend_data=$suspend_data,cmi.launch_data=$launch_data"
	    append returndata ",cmi.student_data.max_time_allowed=$maxtimeallowed,cmi.student_data.time_limit_action=$timelimitaction"
	    append returndata ",cmi.student_data.mastery_score=$masteryscore"
	} else {
	    ad_set_client_property lorsm currenttrackid $currenttrackid
	    #retrieve data other than core
	    db_0or1row get_adlcp_student_data { select max_time_allowed,time_limit_action,mastery_score from lorsm_cmi_student_data where track_id=:currenttrackid; }
	    #
	    ns_log $level "lorsm - retrieved track id in lorsm_cmi_core: $currenttrackid"
	    # summing up session time to total_time
	    set total_time [expr $total_time + $session_time]
	    set total_time_ms [expr $total_time_ms + $session_time_ms]
	    set session_time 0
	    set session_time_ms 0
	    if { $total_time_ms > 100 } { set total_time_ms [expr $total_time_ms - 100] 
		set total_time [expr $total_time +1 ]
	    }
	    # erasing session time from server and updating current total time
	    set todo "UPDATE lorsm_cmi_core SET total_time = '$total_time"
	    append todo "', total_time_ms ='$total_time_ms' "
	    append todo " WHERE track_id=:currenttrackid"
	    db_dml todo $todo
	    if { [db_resultrows] == 1 } { 
		#ns_log $level "lorsm - time processing UPDATE: '$todo' successful"
	    } else { 
		ns_log Warning "lorsm - time processing UPDATE: '$todo' not successful -> please check"
	    } 
	    set todo "UPDATE lorsm_cmi_core SET session_time = '0"
	    append todo "', session_time_ms ='0' "
	    append todo " WHERE track_id=:currenttrackid"
	    db_dml todo $todo
	    if { [db_resultrows] == 1 } { 
		#ns_log $level "lorsm - data processing UPDATE: '$todo' successful"
	    } else { 
		ns_log Warning "lorsm - time processing UPDATE: '$todo' not successful -> please check"
	    } 
	    #AURALOG HACK 
	    #adjust on a per-server basis
	    if { $currentcourse == 11287 } {
		set student_id "testscorm711"
	    }
	    set returndata "cmi.core.student_id=$student_id,cmi.core.student_name=$name,"
	    append returndata "cmi.core.credit=$credit,cmi.core.lesson_status=$lesson_status,cmi.core.entry=$entry,"
	    append returndata "cmi.core.lesson_mode=normal,cmi.core.lesson_location=$lesson_location,"
	    append returndata "cmi.student_preference.language=italian,cmi.comments=$comments,cmi.comments_from_lms=$comments_from_lms"
	    append returndata ",cmi.suspend_data=$suspend_data,cmi.launch_data=$launch_data"
	    append returndata ",cmi.student_data.max_time_allowed=$max_time_allowed,cmi.student_data.time_limit_action=$time_limit_action"
	    append returndata ",cmi.student_data.mastery_score=$mastery_score"
	}
	# AURALOG HACK


	#treating time from table back to system (lorsm.cmi.time fields are showing just seconds)
	set prefix "0"
        set hours [expr int ($session_time/3600) ]
	set minutes [expr int (($session_time - (3600*$hours)) / 60) ]
	set seconds [expr int (($session_time - (3600*$hours)-$minutes*60)) ]
	if { [ string length $hours ] == 1 } { set hours "$prefix$hours" }
	if { [ string length $minutes] == 1 } { set minutes 0$minutes }
	if { [ string length $seconds] == 1 } { set seconds 0$seconds}
	#set session_time "$hours:$minutes:$seconds.00"
	set session_time "$hours:$minutes:$seconds"
	if { ! [empty_string_p $session_time_ms] } { append session_time ".$session_time_ms" }
        set hours [expr int ($total_time/3600) ]
	set minutes [expr int (($total_time - (3600*$hours)) / 60) ]
	set seconds [expr int (($total_time - (3600*$hours)-$minutes*60)) ]
	if { [ string length $hours ] == 1 } { set hours "$prefix$hours" }
	if { [ string length $minutes] == 1 } { set minutes 0$minutes }
	if { [ string length $seconds] == 1 } { set seconds 0$seconds}
	#set total_time "$hours:$minutes:$seconds.00"
	set total_time "$hours:$minutes:$seconds"
	if { ! [empty_string_p $total_time_ms] } { append total_time ".$total_time_ms" }
	#appending time fields to return string
	append returndata ",cmi.core.session_time=$session_time,cmi.core.total_time=$total_time"
	ns_log $level "lorsm - passing data back to applet : $returndata"

	ns_return 200 text/plain "$returndata"
    }

    cmiputcat*
    {
	ns_log $level "lorsm - serving LMSCOMMIT or LMSFINISH from applet"
	ns_log $level "lorsm - received data $data from applet: processing. Reference cmi track is $currenttrackid, while lorsmstudenttrack is: $lorsmstudenttrack"
	set preparselist [lrange [ split $data "," ] 1 end]
	set lista {}
	set value ""
	#here we build a list of request=value. we must do some pattern matching
	foreach couple $preparselist {
	    if { [ regexp ^cmi\.* $couple ] } {
		if { ! [empty_string_p $value]  } {
		    set value [concat [lindex $lista end],$value]
		    ns_log $level "lorsm - PARSER ending recomposing $value "
		    set lista [lreplace $lista end end $value]
		    set value ""
		} else {
		    ns_log $level "lorsm - PARSER full couple $couple "
		    lappend lista $couple
		}
	    } else {
		ns_log $level "lorsm - PARSER partial couple $couple "
		set value [concat $value,$couple]
		ns_log $level "lorsm - PARSER partial couple $couple "
	    }
	}
	if { ! [empty_string_p $value] } {
	    set value [concat [lindex $lista end],$value]
	    ns_log $level "lorsm - PARSER ending recomposing $value "
	    set lista [lreplace $lista end end $value]
	    set value ""
	}
	#end splitting
	foreach couple $lista {
	    set all ""
	    set request ""
	    set value ""
	    #create list named item to contain request and value
	    regexp \(\[^=\]+\)=\(\.*\)$ $couple all request  value
	    #set request "cmi.$request"
	    ns_log $level "lorsm - request from applet is $all that is $request to $value"
	    #set request [lindex $item 0]
	    #set value [lindex $item 1]
	    if { [ string length $value ] == 0 } {	
		ns_log Warning "lorsm - EMPTY settings : '$request' received and empty -> treating this applet anyway"
	    } 
	    #else { 
	    set table [lindex [split $request .] 1]
	    set column [string trim [lindex [split $request .] 2]]
	    switch $table {
		null -
		""    {
		    ns_log Warning "lorsm - EMPTY TABLENAME : '$table', '$column'  not implemented -> not treating this applet request"
		}
		core  {
		    if { [ string compare "total_time" $column ] } {
			# time fields get a separate treatment
			if { [ string first "time" $column ] >0  } { 
			    # conversion of HHHH:MM:SS.SS
			    # removing leading zeros: 
			    # 'regsub {^0*((1-90-9*)|0)$} $x {\1} x'
			    regsub {^0} [lindex [split $value :] 0] "" hours
			    regsub {^0} [lindex [split $value :] 1] "" minutes
			    regsub {^0} [lindex [split $value :] 2] "" seconds
			    regsub {^0} [lindex [split $value .] 1] "" msecs
			    if { [empty_string_p $msecs] } {
				set msecs 0
			    }
			    set column_ms $column
			    append column_ms "_ms"
			    set todo "UPDATE lorsm_cmi_$table SET $column_ms = '" 
			    append todo $msecs
			    append todo "' WHERE track_id=:currenttrackid"
			    db_dml todo $todo
			    if { [db_resultrows] == 1 } { 
				ns_log $level "lorsm - data msecs processing UPDATE: '$todo' successful"
			    } else { 
				ns_log Warning "lorsm - data msecs processing UPDATE: '$todo' not successful -> please check"
			    } 
			    #set minutes [string trim [lindex [split $value :] 1]]
			    #set seconds [string trim [lindex [split $value :] 2]]
			    set value [expr int (( $hours*60 + $minutes ) * 60 + $seconds) ]
			}
			set todo "UPDATE lorsm_cmi_$table SET $column = '" 
			append todo $value
			append todo "' WHERE track_id=:currenttrackid"
			db_dml todo $todo
			if { [db_resultrows] == 1 } { 
			    ns_log $level "lorsm - data processing UPDATE: '$todo' successful"
			} else { 
			    ns_log Warning "lorsm - data processing UPDATE: '$todo' not successful -> please check"
			} 
		    }
		}
		default {
		    ns_log Warning "lorsm - table: '$table', '$column' not implemented -> not treating this applet request"
		}
	    }
	    #} this was the if for empty value setting requests
	}
	switch $functionCalled {
	    cmiputcat {
		#We try setting track exit so that we keep some exit time
		#even if user closes the course without passing by FINISH
		if { $lorsmstudenttrack == "" || $lorsmstudenttrack == 0 } {
		    lorsm::track::exit -track_id $currenttrackid } else {
			#specific for courses for which istrackable is on
			lorsm::track::exit -track_id $lorsmstudenttrack } 
		ns_log $level "lorsm - post LMSCommit (trackid=$currenttrackid)"
		ns_return 200 text/plain "OK"
	    } 
	    cmiputcatONFINISH {
		set lorsmstudenttrack [ad_get_client_property lorsm studenttrack]
		ad_set_client_property lorsm studenttrack ""
		ad_set_client_property lorsm currenttrackid ""
		if { $lorsmstudenttrack == "" || $lorsmstudenttrack == 0 } {
		    lorsm::track::exit -track_id $currenttrackid } else {
			#specific for courses for which istrackable is on
			lorsm::track::exit -track_id $lorsmstudenttrack } 
		ns_return 200 text/plain "OK"
		ns_log $level "lorsm - post LMSFinish (trackid=$currenttrackid) sent ok to applet"
	    }
	}
    }
    default 
    {
	ns_return 504 text/plain "Error=103,ErrorDescription=\"No functionCalled meaningful value provided\""
    }
}
ns_log $level "lorsm - RTE process ending"
