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
            set track_id [db_exec_plsql track_st_new {}]}
        return $track_id
    }


    ad_proc -public exit {
        -track_id:required
    } {
        Sets the time when the student leaves the delivery environment

        @param track_id Track ID given when the delivery session opened
        @author Ernie Ghiglione (ErnieG@mm.st)

    } {

        db_transaction {
            set track_id [db_exec_plsql track_st_exit {}]

            if {$track_id ne ""} {
                # Initialized to prevent errors
                set credit_earned ""
                set elapsed_seconds ""

                db_0or1row get_track {}
                if {[ad_conn -connected_p]} {
                    set package_id [ad_conn package_id]
                } else {
                    set package_id ""
                }
                callback lorsm::track::update \
                    -course_id $course_id \
                    -user_id $user_id \
                    -package_id $package_id \
                    -credit $credit_earned \
                    -track_id $track_id \
                    -start_time $start_time \
                    -end_time $end_time \
                    -elapsed_time $elapsed_seconds
            }
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

        set istrackable [db_string trackable {}]

        if {$istrackable == "f"} {
            return 0
        } else {
            return 1
        }
    }

    ad_proc -private update_elapsed_seconds {
        -track_id
    } {

        set last_item_viewed [db_string select_last_item_viewed {} -default ""]

        if {$last_item_viewed ne ""} {
            set current_seconds [clock seconds]
            set last_seconds [clock scan $last_item_viewed]
            set elapsed_seconds [expr {$current_seconds - $last_seconds}]
            if {$elapsed_seconds > 600} {
                set elapsed_seconds 600
            }
            db_dml update_elapsed_seconds {}
        }
    }


    ad_proc -private get_track_id {
        -user_id
        -man_id
        -community_id
    } {
        Get an existing tracking id from either a client property
        or the database is a session has not been completed but
        they have logged out or their session has expired.
    } {
        set track_id [ad_get_client_property lorsm studenttrack]
        ns_log notice "lors::tack::get_track_id client_property '${track_id}'"
        if {$track_id eq "" || $track_id eq "0"} {
            set track_id [db_string get_track_id {} -default ""]
            ns_log notice "lors::tack::get_track_id database '${track_id}'"
        }
        return $track_id
    }
}


ad_proc -callback lorsm::track::exit_course {
    -course_id
    -user_id
    -track_id
    -credit
    -package_id
} {
    Notify listeners that a user has exited a course
} -


ad_proc -callback lorsm::track::update {
    -course_id
    -user_id
    -track_id
    -credit
    -start_time
    -end_time
    -elapsed_time
    -package_id
} {
    Notify listeners that someting interesting happeneed
    with this course tracking
} -

