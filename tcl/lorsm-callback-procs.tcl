# packages/lorsm/tcl/lorsm-callback-procs.tcl

ad_library {
    
    LORS callback imlementations
    
    @author Enrique Catalan (quio@galileo.edu)
    @creation-date Jul 19, 2005
    @cvs-id $Id$
}

ad_proc -callback merge::MergeShowUserInfo -impl lorsm {
    -user_id:required
} {
    Show lors items of one user
} {
    set msg "lors items"
    set result [list $msg]

    lappend result [list "Student tracks : [db_list sel_student_track { *SQL* }] " ]
    lappend result [list "Student bookmarks: [db_list sel_student_bookmark { *SQL* }] "]
    
    return $result
}

ad_proc -callback merge::MergePackageUser -impl lorsm {
    -from_user_id:required
    -to_user_id:required
} {
    Merge the lors items of two users.
    The from_user_id is the user that will be 
    deleted and all the entries of this user 
    will be mapped to the to_user_id.
    
} {
    set msg "Merging lors"
    ns_log Notice $msg
    set result [list $msg]

    db_transaction {
	db_dml student_track { *SQL* }
	db_dml student_bookmark { *SQL* }
    }

    set result "lors merge is done"
    return $result
}
