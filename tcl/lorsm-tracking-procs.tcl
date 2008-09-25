# packages/lorsm/tcl/lorsm-tracking-procs.tcl

ad_library {
    
    LORSM Student Tracking 
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-05-24
    @arch-tag b8bbe245-6535-4ea9-a4a6-2be2d888b36d
    @cvs-id $Id$
}

#
#  Copyright (C) 2004 Ernie Ghiglione
#
#  This package is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  It is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

namespace eval lorsm::track {

    ad_proc -public new {
	-user_id:required
	-community_id:required
	-course_id:required
    } {
	Tracks everytime a student gets deliver a course.
	The aim of tracking is to see how many time a user has seen a 
	course as well as the time he/she has spent on it. 
	
	@param user_id User ID
	@param community_id Class or Club ID
	@param course_id Course ID (Manifest ID)
	@author Ernie Ghiglione (ErnieG@mm.st)
	
    } {

	db_transaction {
	    set track_id [db_exec_plsql track_st_new {

		select lorsm_student_track__new (
						 :user_id,
						 :community_id,
						 :course_id
						 );

	    }
			 ]
	    
	}
	return $track_id
    }

    ad_proc -public exit {
	-track_id:required
    } {
	Sets the time when the student leaves the delivery environment
	
	@param track_id Track ID (given when the delivery session opened
	@author Ernie Ghiglione (ErnieG@mm.st)
	
    } {

	db_transaction {
	    set track_id [db_exec_plsql track_st_exit {

		select lorsm_student_track__exit (
						 :track_id
						 );

	    }
			 ]
	    
	}
	return $track_id
    }

    ad_proc -public istrackable {
	-course_id:required
	-package_id:required
    } {
	Checks whether the instance of this course in the specified
        community is trackable.

	If it is, then it returns 1. Otherwise, 0.
	
	@param course_id Course ID (or manifest_id)
	@param community_id Commuinity ID.
	@author Ernie Ghiglione (ErnieG@mm.st)
	
    } {

	set istrackable [db_string trackable {
	    select istrackable from ims_cp_manifest_class
	    where man_id = :course_id and lorsm_instance_id = :package_id
	}]

	if {$istrackable == "f"} {
	    return 0
	} else {
	    return 1
	}

    }

}







