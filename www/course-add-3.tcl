ad_page_contract {
    Upload an IMS Content Package 3

    Scope:

    Add files to the CR
    Process imsmanifest.xml
    Determines this is a Blackboard course and if it is process it accordingly.
    Inserts all ims_items, resources and all IMS CP entities into the DB.

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 19 March 2003
    @cvs-id $Id$
} {
    folder_id:integer,notnull
    format_id:integer,notnull
    tmp_dir:optional,notnull
    course_id:integer,notnull
    course_name:notnull
    indb_p:integer,notnull
    fs_package_id:integer,notnull

} -validate {
    non_empty -requires {upload_file.tmpfile:notnull} {
        if {![empty_string_p $upload_file] && (![file exists ${upload_file.tmpfile}] || [file size ${upload_file.tmpfile}] < 4)} {
            ad_complain "[_ lorsm.lt_The_upload_failed_or_]"
        }
    }
}

set context ""

#check permission
set user_id [ad_conn user_id]
ad_require_permission $folder_id admin


# Display progress bar
ad_progress_bar_begin \
    -title "[_ lorsm.Uploading_course]" \
    -message_1 "[_ lorsm.lt_Uploading_and_process]" \
    -message_2 "[_ lorsm.lt_We_will_continue_auto]"


ns_write "<h2>[_ lorsm.lt_Initiating_Updating_l]</h2><blockquote>"

# Is this a Blackboard6 package?
set isBB [lors::imscp::bb6::isBlackboard6 -tmp_dir $tmp_dir]

if {$isBB == 1} {
    ns_write "<p><font color=\"red\"><b>[_ lorsm.lt_Blackboard6_Content_P]</b></font>.<br> [_ lorsm.lt_Modifying_package_to_]"
    ns_write "<blockquote><br> [_ lorsm.lt_Cleaning_up_unused_ap]"
    lors::imscp::bb6::clean_items -tmp_dir $tmp_dir -file "imsmanifest.xml"
    ns_write "<font color=\"green\"><b>[_ lorsm.Done]</b></font>"
    ns_write "<br> [_ lorsm.lt_Renaming_content_type]"
    lors::imscp::bb6::extract_html -tmp_dir $tmp_dir -file "imsmanifest.xml"
    ns_write "<font color=\"green\"><b>[_ lorsm.Done]</b></font></blockquote>"

}


ns_write "<h3> [_ lorsm.lt_Starting_File_Process] </h3>"


db_transaction {

    ## adds folder to the CR
    set parent_id $folder_id
    set fs_dir $tmp_dir

    # checks for write permission on the parent folder
    ad_require_permission $parent_id write

    # get their IP
    set creation_ip [ad_conn peeraddr]

    # checks whether the directory given actually exists
    if {[file exists $fs_dir]} {
        set all_files [list]
        # now that exists, let's create it on the CR

        # gets rid of the path and leaves the name of the directory
        # if course_name is changed, then use that name. Otherwise it will use the default folder name given 
        if {![empty_string_p $course_name]} {
            regexp {([^/\\]+)$} $course_name match cr_dir
        } else {
            regexp {([^/\\]+)$} $fs_dir match cr_dir

        }

	# We need to separate folders (since now all are cr_items) one for the files (content) and the other
	# one for the created cr_items
        set new_parent_id [lors::cr::add_folder -parent_id $parent_id -folder_name $cr_dir]
        set new_items_parent_id [lors::cr::add_folder -parent_id $parent_id -folder_name "${cr_dir}_items"]

	# PERMISSIONS FOR FILE-STORAGE

        # Before we go about anything else, lets just set permissions straight.
         # Disable folder permissions inheritance
         permission::toggle_inherit -object_id $new_parent_id
         permission::toggle_inherit -object_id $new_items_parent_id

	# Set read permissions for community/class dotlrn_member_rel

 	 set community_id [dotlrn_community::get_community_id]

	 set party_id_member [db_string party_id {select segment_id from rel_segments \
						      where group_id = :community_id \
						      and rel_type = 'dotlrn_member_rel'}]

	 permission::grant -party_id $party_id_member -object_id $new_parent_id -privilege read
	 permission::grant -party_id $party_id_member -object_id $new_items_parent_id -privilege read

	# Set read permissions for community/class dotlrn_admin_rel

	set party_id_admin [db_string party_id {select segment_id from rel_segments \
						     where group_id = :community_id \
						     and rel_type = 'dotlrn_admin_rel'}]

	permission::grant -party_id $party_id_admin -object_id $new_parent_id -privilege read
	permission::grant -party_id $party_id_admin -object_id $new_items_parent_id -privilege read

	# Set read permissions for *all* other professors  within .LRN
	# (so they can see the content)

        set party_id_professor [db_string party_id {select segment_id from rel_segments \
                                                     where rel_type = 'dotlrn_professor_profile_rel'}]

	permission::grant -party_id $party_id_professor -object_id $new_parent_id -privilege read
	permission::grant -party_id $party_id_professor -object_id $new_items_parent_id -privilege read

	# Set read permissions for *all* other admins within .LRN
	# (so they can see the content)

        set party_id_admins [db_string party_id {select segment_id from rel_segments \
                                                     where rel_type = 'dotlrn_admin_profile_rel'}]

	permission::grant -party_id $party_id_admins -object_id $new_parent_id -privilege read
	permission::grant -party_id $party_id_admins -object_id $new_items_parent_id -privilege read



        set filesx [lors::cr::add_files -parent_id $new_parent_id -indb_p $indb_p -files [lors::cr::has_files -fs_dir $fs_dir]]

        set all_files [concat $all_files $filesx]

        # get all the directories and files under those dirs

        set dirs [lors::cr::has_dirs -fs_dir $fs_dir]

        set base_parent_id $new_parent_id

        # dirx = directory loop
        set dirx [list "$base_parent_id [list $dirs]"]

        # for each directory found..
        while {[llength $dirx] != 0} {
            set collector [list]
            foreach dir $dirx {
                # if the dirx loop is 0...
                set base_parent_id [lindex $dir 0]

                foreach subdir [lindex $dir 1] {

                    # remove all path 
                    regexp {([^/\\]+)$} $subdir match cr_dir

                    # add the folder to the CR
		    ns_write "[_ lorsm.Processing_folder]<img src=\"/resources/file-storage/folder.gif\">: <b>$cr_dir</b> <br>"
                    set new_cr_folder_id [lors::cr::add_folder -parent_id $base_parent_id -folder_name $cr_dir]
                    lappend collector "$new_cr_folder_id [list [lors::cr::has_dirs -fs_dir $subdir]]"

                    # add files (if any)
                    set files [lors::cr::has_files -fs_dir $subdir]

		    #For display purposes
		    ns_write "[_ lorsm.Processing_files]<blockquote>"
		    foreach file $files {
			set tempval [regsub $tmp_dir $file {}]
			ns_write "<img src=\"/resources/file-storage/file.gif\"> $tempval<font color=\"green\">[_ lorsm.OK]</font><br>"
		    }
		    ns_write "</blockquote>"
		    #

                    if ![empty_string_p $files] {
                        set filesx [lors::cr::add_files -parent_id $new_cr_folder_id -files $files -indb_p $indb_p]
                        set all_files [concat $all_files $filesx]
                    }

                }
            }
            if {[llength $collector] == 0} {
                # then just add the name of the directories
                set dirx $collector
            } else {
                # otherwise, then just add the new directories to the queue
                set dirx
                set dirx $collector
            }
        }

	## Finish adding files to the CR.

	## Now we start processing the imsmanifest.xml file

        ns_write "<p>[_ lorsm.Now_processing]<code>imsmanifest.xml</code> [_ lorsm.file]"
        ## Opens imsmanifest.xml

        # open manifest file with tDOM
        dom parse [::tDOM::xmlReadFile $tmp_dir/imsmanifest.xml] doc
        # gets the manifest tree
        set manifest [$doc documentElement]

        # Gets manifest characteristics
        set man_identifier [lors::imsmd::getAtt $manifest identifier]
        set man_version [lors::imsmd::getAtt $manifest version]

        # DETECT SCORM OR IMS CP
        # NOTE: it requires that the manifest contains a metadata record (which is not always the case) :-(
        ##

        # gets metadata node
        set metadata [$manifest child all metadata]

        if { ![empty_string_p $metadata] } {
	    # gets metadataschema
	    set MetadataSchema [lindex [lindex [lors::imsmd::getMDSchema $metadata] 0] 0]
	    set MetadataSchemaVersion [lindex [lors::imsmd::getMDSchema $metadata] 1]
	    if {![empty_string_p $MetadataSchema]} {
		set isSCORM [regexp -nocase scorm $MetadataSchema]
	    }
	    if {$isSCORM == 1} {
		set man_isscorm 1
	    } else {
		set man_isscorm 0
	    }
	} else {
	    set man_isscorm 0
	}

        if { ![empty_string_p $metadata] } {
            set man_hasmetadata 1
        } else {
            set man_hasmetadata 0
        }

        
        ## Gets manifest title

        if { ![empty_string_p $metadata] } {
            set lom [lindex [lors::imsmd::getLOM $metadata $tmp_dir] 0]
            set prefix [lindex [lors::imsmd::getLOM $metadata $tmp_dir] 1]
            if { $lom != 0 } {
                # Get title
                set manifest_title_lang [lindex [lindex [lors::imsmd::mdGeneral -element title -node $lom -prefix $prefix] 0] 0]
                set manifest_title [lindex [lindex [lors::imsmd::mdGeneral -element title -node $lom -prefix $prefix] 0] 1]
                # set context
                set context "[_ lorsm.lt_Importing_manifest_ti]"

                ## Gets manifest description
                
                set manifest_descrip_lang [lindex [lindex [lors::imsmd::mdGeneral -element description -node $lom -prefix $prefix] 0] 0]
                set manifest_descrip [lindex [lindex [lors::imsmd::mdGeneral -element description -node $lom -prefix $prefix] 0] 1]

                # adds course information for display


                # Gets Rights info
                set copyright [lors::imsmd::mdRights -element copyrightandotherrestrictions -node $lom -prefix $prefix]
                if { ![empty_string_p $copyright] } {
                    set copyright_s [lindex [lindex [lindex $copyright 0] 0] 1]
                    set copyright_v [lindex [lindex [lindex $copyright 0] 1] 1]
                    set cr_descrip [lors::imsmd::mdRights -element description -node $lom -prefix $prefix]
                    set cr_descrip_s [lindex [lindex $cr_descrip 0] 1]


                }


            } else {
                set context "[_ lorsm.lt_Importing_No_Metadata]"
            }

        }



        # Gets the organizations

        set organizations [$manifest child all organizations]
        set man_orgs_default [lors::imsmd::getAtt $organizations default]
	ns_log Debug "lors-debug course-add-3 Organizations: $organizations *******************"
        set man_id [lors::imscp::manifest_add \
			-course_name $course_name \
			-identifier $man_identifier \
			-version $man_version \
			-orgs_default $man_orgs_default \
			-hasmetadata $man_hasmetadata \
			-course_presentation_format $format_id \
			-isscorm $man_isscorm \
			-folder_id $new_items_parent_id \
                        -fs_package_id $fs_package_id \
		        -community_id $community_id \
		        -content_folder_id $new_parent_id]
#Borrar
	ns_log Debug "lors-debug course-add-3 isscorm: $man_isscorm"
	set name "nombre cambiado"
#	db_dml update "update ims_cp_manifests
	#        set course_name = :name_name, identifier = :man_identifier, version = :man_version, 
	 #           orgs_default = :man_orgs_default, 
	  #          folder_id = :new_items_parent_id, fs_package_id= :fs_package_id, 
	   #         course_presentation_format = :format_id
	    #    where man_id = :man_id"
#Borrar

	ns_log Debug "lors-debug course-add-3 man_id: $man_id"

	ns_write "[_ lorsm.lt_Granting_permissions__1]<br>"

	# PERMISSIONS FOR MANIFEST and learning objects

	# set up in the same way as permissions for the file storage
	# objects. As we want to maintain consistency btw the
	# learnining objects and their content

         # Disable folder permissions inheritance
         permission::toggle_inherit -object_id $man_id

	# Set read permissions for community/class dotlrn_member_rel

 	 set community_id [dotlrn_community::get_community_id]

	 set party_id_member [db_string party_id {select segment_id from rel_segments \
						      where group_id = :community_id \
						      and rel_type = 'dotlrn_member_rel'}]

	 permission::grant -party_id $party_id_member -object_id $man_id -privilege read

	# Set read permissions for community/class dotlrn_admin_rel

	set party_id_admin [db_string party_id {select segment_id from rel_segments \
						     where group_id = :community_id \
						     and rel_type = 'dotlrn_admin_rel'}]

	permission::grant -party_id $party_id_admin -object_id $man_id -privilege read

	# Set read permissions for *all* other professors  within .LRN
	# (so they can see the content)

        set party_id_professor [db_string party_id {select segment_id from rel_segments \
                                                     where rel_type = 'dotlrn_professor_profile_rel'}]

	permission::grant -party_id $party_id_professor -object_id $man_id -privilege read

	# Set read permissions for *all* other admins within .LRN
	# (so they can see the content)

        set party_id_admins [db_string party_id {select segment_id from rel_segments \
                                                     where rel_type = 'dotlrn_admin_profile_rel'}]

	permission::grant -party_id $party_id_admins -object_id $man_id -privilege read


	# Done with Manifest and learning object Permissions


	ns_write "[_ lorsm.lt_Adding_course_name_Ma]<br>"

        if {$man_hasmetadata == 1} {
            # adds manifest metadata
            set aa [lors::imsmd::addMetadata \
                        -acs_object $man_id \
                        -node $metadata \
                        -dir $tmp_dir]

	ns_write "[_ lorsm.lt_Adding_Manifest_Metad]<br>"

        }

        if { ![empty_string_p $organizations] } {

	    # for multiple organizations
            set add [list]

            foreach organization [$organizations child all organization] {
		ns_log Debug "lors-debug course-add-3 organization: $organization"
                #set org_identifier [lors::imsmd::getResource -node $organization -att identifier]

                set org_identifier [lors::imsmd::getResource -node $organization -att identifier]
                set org_structure [lors::imsmd::getResource -node $organization -att structure]
		if {![empty_string_p [$organization child all title]]} {
		    set org_title [lors::imsmd::getElement [$organization child all title]]
		} else {
		    set org_title ""
		}
                set org_hasmetadata [lors::imsmd::hasMetadata $organization]
		ns_log Debug "lors-debug course-add-3 org_hasmetadata: $org_hasmetadata"
                set org_id [lors::imscp::organization_add \
                                -man_id $man_id \
                                -identifier $org_identifier \
                                -structure $org_structure \
                                -title $org_title \
                                -hasmetadata $org_hasmetadata\
				-org_folder_id $new_items_parent_id]

		ns_write "[_ lorsm.lt_Adding_Organization_o]<br>"

		ns_log Debug "lors-debug course-add-3 org_id: $org_id"

                if { $org_hasmetadata == 1} {
                    # adds manifest metadata
                    set aa [lors::imsmd::addMetadata \
                                -acs_object $org_id \
                                -node [lors::imsmd::getMDNode $organization] \
                                -dir $tmp_dir]
                }

                set list_items [lors::imscp::getItems $organization]

#                ns_write "[_ lorsm.lt_here_is_list_items_li]"

                set add [concat $add [lors::imscp::addItems -itm_folder_id $new_items_parent_id -org_id $org_id $list_items 0 $tmp_dir]]
		ns_log Debug "lors-debug course-add-3 add: $add" 

		set tempval [llength $add]
		ns_write "[_ lorsm.lt_Adding_tempval_items_]<br>"

            }


        }

        set l_files [list]

        set resources [$manifest child all resources]

        set resourcex [$resources child all resource]

        if { ![empty_string_p $resourcex] } {

            set res_list [list]
            foreach resource $resourcex {
                set res_identifier [lors::imsmd::getResource -node $resource -att identifier]
                set res_type [lors::imsmd::getResource -node $resource -att type]
                set res_href [lors::imsmd::getResource -node $resource -att href]
                set res_dependencies [lors::imsmd::getResource -node $resource -att dependencies]
                set res_hasmetadata [lors::imsmd::hasMetadata $resource]
                set res_files [lors::imsmd::getResource -node $resource -att files]
                set res_scormtype [lors::imsmd::getAtt $resource adlcp:scormtype]

                # Integration with other packages
                # This callback gets the href of the imported content (if some package imported it)
                set res_href_tmp [callback -catch lors::import -res_type $res_type -res_href $res_href -tmp_dir $tmp_dir -community_id $community_id]
                if {![empty_string_p $res_href_tmp]} {
                    set res_href $res_href_tmp
                }

                set resource_id [lors::imscp::resource_add \
                                     -man_id $man_id \
                                     -identifier $res_identifier \
                                     -type $res_type \
                                     -href $res_href \
                                     -scorm_type $res_scormtype \
                                     -hasmetadata $res_hasmetadata \
				     -res_folder_id $new_items_parent_id]

		ns_write "[_ lorsm.lt_Adding_resource_res_i_2]<br>"
		
		lappend res_list [concat "$resource_id $res_identifier"]

		


                if {$res_hasmetadata == 1} {
                    set res_md_add [lors::imsmd::addMetadata \
                                        -acs_object $resource_id \
                                        -node [lors::imsmd::getMDNode $resource] \
                                        -dir $tmp_dir]

		    ns_write "[_ lorsm.lt_Adding_resource_res_i_3]<br>"

                }


                foreach dependency $res_dependencies {

                    set dep_id [lors::imscp::dependency_add \
                                    -res_id $resource_id \
                                    -identifierref $dependency]

		    ns_write "[_ lorsm.lt_Adding_resource_depen]<br>"

                }


                foreach file $res_files {
                    lappend l_files [list [lindex $file 0] $resource_id [lindex $file 1]]

                    #                ns_write "[_ lorsm.lt_resource_id_res_ident]"
                    #                ns_write "\t$file \n"
                }
            }
        }

        # gets the resources
        set resources [$manifest child all resources]
        
    } else {
        # Error MSG here
        #ns_write "[_ lorsm.no_page]"
    }


    # Here's where we link items and resources.  Take into
    # account that a resources can have 1 to many items


    # So first, let's create a list of only item_identifierrefs
    # [lindex $add 1]. Therefore we can do a lsearch -exact instead of
    # a -regexp

    foreach ref $add {
	lappend i_identref [lindex $ref 1]
    }

    foreach resource $res_list {

	set find_item_id [lsearch -all -exact $i_identref [lindex $resource 1]]

	if {$find_item_id != -1} {

	    foreach item_to_res $find_item_id {

		set item_to_resource [lors::imscp::item_to_resource_add \
					  -item_id [lindex [lindex $add $item_to_res] 0] \
					  -res_id [lindex $resource 0]
				      ]
	    }

	} 

    }

    ns_write "[_ lorsm.lt_Now_we_are_almost_don]<br>"

    foreach file $l_files {

        set filename [lindex $file 0]

        set found_file [lsearch -all -regexp $all_files $filename]

	if {[llength $found_file] > 1} {
	    # we are suppose to get only one element back, so we have
	    # to refine the search a bit more.
	    set found_file [lsearch -all -regexp $all_files $tmp_dir/$filename]
	}

	if {![empty_string_p $found_file]} {
	    set file_id [lindex [lindex $all_files $found_file] 3]
            set file_rev_id [content::item::get_live_revision -item_id $file_id]
	    set res_id  [lindex $file 1]
	    set file_hasmetadata [lindex $file 2]

	    regexp {([^/\\]+)$} $filename match filex

	    if {$file_hasmetadata != 0} {
		set hasmetadata 1
	    } else {
		set hasmetadata 0
	    }

	    set fileadd [lors::imscp::file_add \
			     -file_id $file_rev_id \
			     -res_id $res_id \
			     -pathtofile $filename \
			     -filename $filex \
			     -hasmetadata $hasmetadata]

	    ns_write "[_ lorsm.Adding_file_filex]<br>"


	    if {$file_hasmetadata != 0} {
		set add_file_metadata [lors::imsmd::addMetadata \
					   -acs_object $file_id \
					   -node $file_hasmetadata \
					   -dir $tmp_dir]

		ns_write "[_ lorsm.lt_Adding_file_filex_met_1]<br>"
	    }
	}

    }


    # Delete temporary directory
    ns_write "[_ lorsm.lt_Deleting_temporary_fo]<br>"
    ns_log Debug "Delete temporary folder $tmp_dir"
    lors::imscp::deltmpdir $tmp_dir

    ns_write "[_ lorsm.Done]<p></blockquote><hr>"

    # jump to the front page
    ad_progress_bar_end -url [apm_package_url_from_id [ad_conn package_id]]


}
