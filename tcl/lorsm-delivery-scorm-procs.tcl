# packages/lorsm/tcl/lorsm-delivery-scorm-procs.tcl

ad_library {

    LORSM Scorm delivery procedures

    @author Michele Slocovich (m.s@sii.it)
    @creation-date 2007-07-02
    @cvs-id
}

#
#  Copyright (C) 2007 Michele Slocovich
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

namespace eval lorsm::delivery::scorm {

    ad_proc -public check_parents {
        -ims_item_id:required
    } {
        Given a lesson status checks whether to propagate the status change
        to upper levels. Lesson statuses are kept within lorsm_cmi_core table.
        Differing from "standard" tracks, folders, organisations and manifests
        are used as keys to propagate status, so that once a course is finished,
        the corresponding manifest level track in lorsm_cmi_core would show it.

        @param
        @author Michele Slocovich (m.s@sii.it)

    } {

        upvar currentcourse currentcourse
        upvar community_id  community_id
        upvar user_id user_id
        upvar username username
        upvar name name

        ns_log debug "SCORM parents: LOOKING FOR PARENTS FOR $ims_item_id"

        set father 0

        if { ! [ db_0or1row someinfo {} ] } {
                    ns_log warning "Parents: no parent "
                    #should look harder: the calling items should be ORG
                    #as a parent and set it so.
                    if { [db_0or1row isanorg {}] } {

                        ns_log debug "SCORM parents: father is man: $father"
                        #we should now do something to set the thing ok
                    } else {
                        ns_log warning "SCORM parents: no father found at all"
                    }
                }

            if { $father > 0 } {
                ns_log debug "SCORM parents: Found parent: $father  which is $father_type "
                #the following query should include "self" where self is current ims_item_id

                if { [ string equal $father_type "ims_manifest_object" ] } {
                    #since we have a manifest i will check all orgs below.
                    if { [ db_0or1row hasmanincompletedchildren {} ] } {

                        ns_log debug "SCORM parents: at least one incomplete sub-org ($item_id)"
                        set target_status "incomplete"
                        set target_comment "MAN TRACKING"

                    } else {
                        ns_log debug  "SCORM parents: no incompleted sub-orgs"
                        set target_status "completed"
                        set target_comment "MAN TRACKING"
                    }

                } else {
                    if { [ db_0or1row hasblockincompletedchildren {} ] } {

                        ns_log debug "BLOCK: at least 1 incomplete children (see $item_id)"
                        set target_status "incomplete"
                        set target_comment "BLOCK TRACKING"

                    } else {
                        ns_log debug  "BLOCK: no incomplete or unvisited children"
                        set target_status "completed"
                        set target_comment "BLOCK TRACKING"
                    }
                }
                    ns_log debug "SCORM Parents: We are going to (check) set:
                        $target_status on $father "

                    if { [ db_0or1row isanysuspendedsession {} ] } {

                        if { ! [ string equal lesson_status_old target_status ] } {
                            #UPDATE
                            set todo "UPDATE lorsm_cmi_core SET lesson_status = '$target_status' "
                            append todo " WHERE track_id=$block_track_id"
                            db_dml todo $todo
                            if { [db_resultrows] == 1 } {
                                ns_log debug "SCORM: lesson_status processing UPDATE: '$todo' succesful"

                                #POST PROCESSING
                                if { ! [string equal $father_type "ims_manifest_object" ] } {
                                    ns_log debug "SCORM parents: calling self"
                                    lorsm::delivery::scorm::check_parents -ims_item_id $father
                                    ns_log debug "SCORM parents: end calling self"
                                }
                            } else {
                                    ns_log warning "SCORM parents: lesson_status processing UPDATE: '$todo' not successful -> please check"
                            }

                        } else {
                            ns_log debug "SCORM Parents: not updating, upper status already set"
                        }
                    } else {
                        #fresh tracking record
                        set block_track_id [lorsm::track::new \
                                                -user_id $user_id \
                                                -community_id $community_id \
                                                -course_id $currentcourse]
                                                #INSERT NEW TRACK FOR ITEM
                        db_dml lmsinitialize {}

                        if { [db_resultrows] == 1 } {
                            ns_log debug "SCORM: lesson_status processing INSERT: $block_track_id to $target_status successful"
                            #POST PROCESSING
                            if { ! [string equal $father_type "ims_manifest_object" ] } {
                                ns_log debug "SCORM parents: calling self"
                                lorsm::delivery::scorm::check_parents -ims_item_id $father
                                ns_log debug "SCORM parents: end calling self"
                            }
                        } else {
                            ns_log warning "SCORM parents: lesson_status processing INSERT: '$block_track_id' to $target_status not successful -> please check"
                        }
                    }

            } else {
                ns_log Warning "SCORM parents: no father found"
            }
        return 0
    }
}
