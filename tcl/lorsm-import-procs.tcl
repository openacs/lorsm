# packages/lorsm/tcl/lorsm-import-procs.tcl

ad_library {

    LORS Management Import Procedures

    @author eduardo.perez@uc3m.es
    @creation-date 2006-01-19
    @cvs-id $Id$
}

#
#  Copyright (C) 2006 Eduardo Perez
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

ad_proc -public lorsm::import_imscp {
    -upload_file:required
    -tmp_dir:required
} {
} {

    set user_id [ad_conn user_id]
    set community_id [lors::get_community_id]

    # Gets file-storage root folder_id
    # eventually, we should provide an option so it can be imported in
    # different subfolders
    set fs_package_id [site_node_apm_integration::get_child_package_id \
                        -package_id [lors::get_community_package_id] \
                        -package_key "file-storage"]

    #set fs_package_id [apm_package_id_from_key "file-storage"] -- if used
    # with OpenACS

    # Gets root folder and root folder name
    set folder_id [fs::get_root_folder -package_id $fs_package_id]
    set folder_name [fs::get_object_name -object_id $folder_id]

    # Gets whether the file-storage instance is a indb_p or file system
    # (StoreFilesInDatabaseP) one not that we use it now -since we are
    # currently putting everything on the file system, but eventually we
    # will have the option to put it on the db.

    set indb_p [parameter::get -parameter "StoreFilesInDatabaseP" \
                    -package_id $fs_package_id]

    # Gets URL for file-storage package

    set fs_url [apm_package_url_from_id $fs_package_id]

    set user_id [ad_conn user_id]
    set package_id [ad_conn package_id]
    # check for admin permission on folder
    set admin_p [permission::permission_p \
                    -party_id $user_id \
                    -object_id $package_id \
                    -privilege admin]

    # set course id
    set course_id 1

    set tmpfile $upload_file
    set upload_file [file tail $upload_file]

    # if it is not blank...
    if {![empty_string_p $upload_file]} {
        ns_log Debug "LORS Package: made directory $tmp_dir to extract from
            $tmpfile ($upload_file)\n"
        set allfiles [lors::imscp::dir_walk $tmp_dir]

    } else {
        set allfiles [lors::imscp::dir_walk $directory]
    }

    # Permissions on target folder
    ad_require_permission $folder_id admin

    # unzips the file
    if { ![empty_string_p $upload_file] &&
        [ catch {set tmp_dir [lors::imscp::expand_file $upload_file $tmpfile \
                                lors-imscp-$course_id] } errMsg] } {
        ad_return_complaint 1 "[_ lorsm.lt_The_uploaded_file_doe]"
        ad_script_abort
    }

    # search for manifest file
    set file imsmanifest.xml

    set manifest [lors::imscp::findmanifest $tmp_dir $file]

    # see if the file actually is where it suppose to be. Othewise abort
    if {$manifest == 0} {
        lors::imscp::deltmpdir $tmp_dir
        ad_return_complaint 1 "[_ lorsm.lt_There_is_no_file_with_1]"
    }

    # Is this a Blackboard6 package?
    set isBB [lors::imscp::bb6::isBlackboard6 -tmp_dir $tmp_dir]

    if {$isBB == 1} {
        # we generate metadata for the file
        ns_log Notice "Generating MD record from Blackboard6 package $tmp_dir --"
        lors::imscp::bb6::create_MD -tmp_dir $tmp_dir -file $file
        ns_log Notice "Done!"

    }

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

        ## Opens imsmanifest.xml

        # open manifest file with tDOM
        dom parse [::tDOM::xmlReadFile $manifest] doc
        # gets the manifest tree
        set manifest [$doc documentElement]

        # gets metadata node
        set metadata [$manifest child all metadata]

        # DETECT SCORM OR IMS CP
        set isSCORM [lors::imscp::isSCORM -node $manifest]

        ## Gets manifest title
        if { ![empty_string_p $metadata] } {
        # gets metadataschema
            set MetadataSchema [lindex [lindex [lors::imsmd::getMDSchema $metadata] 0] 0]
            set MetadataSchemaVersion [lindex [lors::imsmd::getMDSchema $metadata] 1]
            set lom [lindex [lors::imsmd::getLOM $metadata $tmp_dir] 0]
            set prefix [lindex [lors::imsmd::getLOM $metadata $tmp_dir] 1]

            if { $lom != 0 } {
                # Get title
                set manifest_title_lang [lindex \
                                            [lindex [lors::imsmd::mdGeneral \
                                                        -element title \
                                                        -node $lom \
                                                        -prefix $prefix] 0] 0]

                set manifest_title [lindex
                                        [lindex [lors::imsmd::mdGeneral \
                                                    -element title \
                                                    -node $lom \
                                                    -prefix $prefix] 0] 1]
                # set context
                set context "[_ lorsm.lt_Importing_manifest_ti]"

                ## Gets manifest description

                set manifest_descrip_lang [lindex \
                                            [lindex [lors::imsmd::mdGeneral \
                                                        -element description \
                                                        -node $lom \
                                                        -prefix $prefix] 0] 0]

                set manifest_descrip [lindex \
                                        [lindex [lors::imsmd::mdGeneral \
                                                    -element description \
                                                    -node $lom \
                                                    -prefix $prefix] 0] 1]

                # Gets Rights info
                set copyright [lors::imsmd::mdRights \
                                -element copyrightandotherrestrictions \
                                -node $lom \
                                -prefix $prefix]

                if { $copyright != 0 } {
                    set copyright_s [lindex [lindex [lindex $copyright 0] 0] 1]
                    set copyright_v [lindex [lindex [lindex $copyright 0] 1] 1]
                    set cr_descrip [lors::imsmd::mdRights \
                                        -element description \
                                        -node $lom \
                                        -prefix $prefix]
                    set cr_descrip_s [lindex [lindex $cr_descrip 0] 1]
                }
            } else {
                # Didn't find LOM although it did find the Metadata schema and
                # version
                regexp {([^/\\]+)$} $tmp_dir match manifest_title
                set context "[_ lorsm.lt_Importing_No_Metadata]"
            }
        } else {
            # manifest title doesn't exist, so we create one for it.
            regexp {([^/\\]+)$} $tmp_dir match manifest_title
            set context "[_ lorsm.lt_Importing_No_Metadata]"
        }

        # Gets the organizations

        set organizations [$manifest child all organizations]
        if { ![empty_string_p $organizations] } {
            set num_organizations [$organizations child all organization]
            set items 0

            foreach organization $num_organizations {
                set items  [expr $items + [lors::imscp::countItems $organization]]
            }
        }

        # gets the resources
        set resources [$manifest child all resources]

        # Complain if there's no resources
        if {[empty_string_p $resources]} {
            ad_return_complaint 1 "[_ lorsm.lt_The_package_you_are_t_1]"
            ad_script_abort
        }

        set resourcex [$resources child all resource]
        if { $isSCORM == 1 } {
            # The imsmanifest.xml file contains a SCORM course

            # extract all the resources and files
            set scos 0
            set assets 0
            set sharableresources 0
            set files 0

            if { ![empty_string_p $resources] } {
                foreach resourcex [$resources child all resource] {
                    # gets the type of resource
                    set resource_scormtype [string tolower [lors::imsmd::getAtt \
                        $resourcex adlcp:scormtype]]

                    switch $resource_scormtype {
                        sco {
                            incr scos

                        } asset {
                            incr assets

                        } sharableresource {
                            incr sharableresources
                        }
                    }

                    set files [expr $files + [llength [lors::imsmd::getResource \
                                                            -node $resourcex \
                                                            -att files]]]
                }
            }

            # end isSCORM if
        } else {
            # The imsmanifest.xml file corresponds to a IMS CP (but not SCORM)

            set files 0
            if { ![empty_string_p $resourcex] } {
                foreach resource $resourcex {
                    set files [expr $files + [llength [lors::imsmd::getResource \
                                                        -node $resource \
                                                        -att files]]]
                }
            }
        }

    } else {
        # Error MSG here
        ad_return_complaint 1 "[_ lorsm.lt_There_has_been_a_prob]"
        ad_script_abort
    }

    # Is this a Blackboard6 package?
    set isBB [lors::imscp::bb6::isBlackboard6 -tmp_dir $tmp_dir]

    if {$isBB == 1} {
        ns_write "<p><span style=\"color: red\"><strong>[_ lorsm.lt_Blackboard6_Content_P]</strong></span>.<br> [_ lorsm.lt_Modifying_package_to_]"
        ns_write "<p><br> [_ lorsm.lt_Cleaning_up_unused_ap]"
        lors::imscp::bb6::clean_items -tmp_dir $tmp_dir -file "imsmanifest.xml"
        ns_write "<span style=\"color: green\"><strong>[_ lorsm.Done]</strong></span>"
        ns_write "<br> [_ lorsm.lt_Renaming_content_type]"
        lors::imscp::bb6::extract_html -tmp_dir $tmp_dir -file "imsmanifest.xml"
        ns_write "<span style=\"color:green\"><strong>[_ lorsm.Done]</strong></span></p>"

    }

    ns_write "<h3> [_ lorsm.lt_Starting_File_Process] </h3>"

    db_transaction {

        ## adds folder to the CR
        set parent_id $folder_id
        set fs_dir $tmp_dir

        # get their IP
        set creation_ip [ad_conn peeraddr]

        # checks whether the directory given actually exists
        if {[file exists $fs_dir]} {
            set all_files [list]
            # now that exists, let's create it on the CR

            # gets rid of the path and leaves the name of the directory
            # if course_name is changed, then use that name. Otherwise it will use the default folder name given
            #set course_name $upload_file
            # FIX ME: the course name is taken from the uploaded file, it should be taken somewhere else
            regsub {(\.[a-zA-Z0-9]+)$} $upload_file "" course_name
            regsub -all {_} $course_name " " course_name

            regexp {([^/\\]+)$} $fs_dir match cr_dir

            # We need to separate folders (since now all are cr_items) one for the files (content) and the other
            # one for the created cr_items
            set new_parent_id [lors::cr::add_folder \
                                -parent_id $parent_id \
                                -folder_name $cr_dir]
            set new_items_parent_id [lors::cr::add_folder \
                                        -parent_id $parent_id \
                                        -folder_name "${cr_dir}_items"]

            # PERMISSIONS FOR FILE-STORAGE

            # Before we go about anything else, lets just set permissions straight.
            # Disable folder permissions inheritance
            permission::toggle_inherit -object_id $new_parent_id
            permission::toggle_inherit -object_id $new_items_parent_id

            # Set read permissions for community/class dotlrn_member_rel

            set community_id [lors::get_community_id]

            set party_id_member [db_string party_id_member {}]

            permission::grant \
                -party_id $party_id_member \
                -object_id $new_parent_id \
                -privilege read

            permission::grant \
                -party_id $party_id_member \
                -object_id $new_items_parent_id \
                -privilege read

            # Set read permissions for community/class dotlrn_admin_rel

            set party_id_admin [db_string party_id_admin {}]

            permission::grant \
                -party_id $party_id_admin \
                -object_id $new_parent_id \
                -privilege read

            permission::grant \
                -party_id $party_id_admin \
                -object_id $new_items_parent_id \
                -privilege read

            # Set read permissions for *all* other professors  within .LRN
            # (so they can see the content)

            set party_id_professor [db_string party_id_professor {}]

            permission::grant \
                -party_id $party_id_professor \
                -object_id $new_parent_id \
                -privilege read

            permission::grant \
                -party_id $party_id_professor \
                -object_id $new_items_parent_id \
                -privilege read

            # Set read permissions for *all* other admins within .LRN
            # (so they can see the content)

            set party_id_admins [db_string party_id_admin_profile {}]

            permission::grant \
                -party_id $party_id_admins \
                -object_id $new_parent_id \
                -privilege read

            permission::grant \
                -party_id $party_id_admins \
                -object_id $new_items_parent_id \
                -privilege read

            set filesx [lors::cr::add_files \
                            -parent_id $new_parent_id \
                            -indb_p $indb_p \
                            -files [lors::cr::has_files -fs_dir $fs_dir]]

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
                        ns_write "[_ lorsm.Processing_folder]<img src=\"/resources/file-
                            storage/folder.gif\">: <b>$cr_dir</b> <br>"
                        set new_cr_folder_id [lors::cr::add_folder \
                                                -parent_id $base_parent_id \
                                                -folder_name $cr_dir]
                        lappend collector "$new_cr_folder_id [list
                            [lors::cr::has_dirs -fs_dir $subdir]]"

                        # add files (if any)
                        set files [lors::cr::has_files -fs_dir $subdir]

                #For display purposes
                ns_write "[_ lorsm.Processing_files]<p>"
                foreach file $files {
                    set tempval [regsub $tmp_dir $file {}]
                    ns_write "<img src=\"/resources/file-storage/file.gif\">
                        $tempval<span style=\"color:green\">[_ lorsm.OK]</span><br>"
                }
                ns_write "</p>"
                #

                if ![empty_string_p $files] {
                    set filesx [lors::cr::add_files \
                                    -parent_id $new_cr_folder_id \
                                    -files $files \
                                    -indb_p $indb_p]
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
                    set manifest_title_lang [lindex \
                                                [lindex \
                                                    [lors::imsmd::mdGeneral \
                                                            -element title \
                                                            -node $lom \
                                                            -prefix $prefix] 0] 0]

                    set manifest_title [lindex \
                                            [lindex \
                                                [lors::imsmd::mdGeneral \
                                                    -element title \
                                                    -node $lom \
                                                    -prefix $prefix] 0] 1]
                    # set context
                    set context "[_ lorsm.lt_Importing_manifest_ti]"

                    ## Gets manifest description

                    set manifest_descrip_lang [lindex \
                                                [lindex [lors::imsmd::mdGeneral \
                                                            -element description \
                                                            -node $lom \
                                                            -prefix $prefix] 0] 0]
                    set manifest_descrip [lindex
                                            [lindex [lors::imsmd::mdGeneral \
                                                        -element description \
                                                        -node $lom \
                                                        -prefix $prefix] 0] 1]

                    # adds course information for display


                    # Gets Rights info
                    set copyright [lors::imsmd::mdRights \
                                    -element copyrightandotherrestrictions \
                                    -node $lom \
                                    -prefix $prefix]

                    if { ![empty_string_p $copyright] } {
                        set copyright_s [lindex
                                            [lindex
                                                [lindex $copyright 0] 0] 1]
                        set copyright_v [lindex
                                            [lindex
                                                [lindex $copyright 0] 1] 1]
                        set cr_descrip [lors::imsmd::mdRights \
                                            -element description \
                                            -node $lom \
                                            -prefix $prefix]
                        set cr_descrip_s [lindex [lindex $cr_descrip 0] 1]
                    }
                } else {
                    set context "[_ lorsm.lt_Importing_No_Metadata]"
                }
            }

            # Gets the organizations

            set organizations [$manifest child all organizations]
            set man_orgs_default [lors::imsmd::getAtt $organizations default]

            set man_id [lors::imscp::manifest_add \
                -course_name $course_name \
                -identifier $man_identifier \
                -version $man_version \
                -orgs_default $man_orgs_default \
                -hasmetadata $man_hasmetadata \
                -isscorm $man_isscorm \
                -folder_id $new_items_parent_id \
                -fs_package_id $fs_package_id \
                -community_id $community_id \
                -content_folder_id $new_parent_id]

            ns_write "[_ lorsm.lt_Granting_permissions__1]<br>"

            # PERMISSIONS FOR MANIFEST and learning objects

            # set up in the same way as permissions for the file storage
            # objects. As we want to maintain consistency btw the
            # learnining objects and their content

            # Disable folder permissions inheritance
            permission::toggle_inherit -object_id $man_id

            # Set read permissions for community/class dotlrn_member_rel

            set community_id [lors::get_community_id]

            set party_id_member [db_string party_id_member {}]

            permission::grant \
                -party_id $party_id_member \
                -object_id $man_id \
                -privilege read

            # Set read permissions for community/class dotlrn_admin_rel

            set party_id_admin [db_string party_id_admin {}]

            permission::grant \
                -party_id $party_id_admin \
                -object_id $man_id \
                -privilege read

            # Set read permissions for *all* other professors  within .LRN
            # (so they can see the content)

            set party_id_professor [db_string party_id_professor {}]

            permission::grant \
                -party_id $party_id_professor \
                -object_id $man_id \
                -privilege read

            # Set read permissions for *all* other admins within .LRN
            # (so they can see the content)

            set party_id_admins [db_string party_id_admin_profile {}]

            permission::grant \
                -party_id $party_id_admins \
                -object_id $man_id \
                -privilege read

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
                    set org_identifier [lors::imsmd::getResource \
                                            -node $organization \
                                            -att identifier]
                    set org_identifier [lors::imsmd::getResource \
                                            -node $organization \
                                            -att identifier]
                    set org_structure [lors::imsmd::getResource \
                                            -node $organization \
                                            -att structure]

                    if {![empty_string_p [$organization child all title]]} {
                        set org_title [lors::imsmd::getElement \
                            [$organization child all title]]
                    } else {
                        set org_title ""
                    }

                    set org_hasmetadata [lors::imsmd::hasMetadata $organization]
                    set org_id [lors::imscp::organization_add \
                                    -man_id $man_id \
                                    -identifier $org_identifier \
                                    -structure $org_structure \
                                    -title $org_title \
                                    -hasmetadata $org_hasmetadata\
                                    -org_folder_id $new_items_parent_id]

                    ns_write "[_ lorsm.lt_Adding_Organization_o]<br>"


                    if {$org_hasmetadata == 1} {
                        # adds manifest metadata
                        set aa [lors::imsmd::addMetadata \
                                    -acs_object $org_id \
                                    -node [lors::imsmd::getMDNode $organization] \
                                    -dir $tmp_dir]
                    }

                    set list_items [lors::imscp::getItems $organization]

                    # ns_write "[_ lorsm.lt_here_is_list_items_li]"
                    set add [concat $add [lors::imscp::addItems \
                                            -itm_folder_id $new_items_parent_id \
                                            -org_id $org_id $list_items 0 $tmp_dir]]

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
                    set res_identifier [lors::imsmd::getResource \
                        -node $resource \
                        -att identifier]
                    set res_type [lors::imsmd::getResource \
                                    -node $resource \
                                    -att type]
                    set res_href [lors::imsmd::getResource \
                                    -node $resource \
                                    -att href]
                    set res_dependencies [lors::imsmd::getResource \
                                            -node $resource \
                                            -att dependencies]
                    set res_hasmetadata [lors::imsmd::hasMetadata $resource]
                    set res_files [lors::imsmd::getResource \
                                    -node $resource \
                                    -att files]
                    set res_scormtype [lors::imsmd::getAtt $resource adlcp:scormtype]

                    # Integration with other packages
                    # This callback gets the href of the imported content (if some package imported it)
                    set res_href_tmp [callback \
                                        -catch lors::import \
                                        -res_type $res_type \
                                        -res_href $res_href \
                                        -tmp_dir $tmp_dir \
                                        -community_id $community_id]

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
                        lappend l_files [list
                                            [lindex $file 0] $resource_id
                                            [lindex $file 1]]
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
            set find_item_id [lsearch -all -exact $i_identref \
                [lindex $resource 1]]

            if {$find_item_id != -1} {

                foreach item_to_res $find_item_id {
                set item_to_resource [lors::imscp::item_to_resource_add \
                              -item_id [lindex [lindex $add $item_to_res] 0] \
                              -res_id [lindex $resource 0]]
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
                set file_rev_id [content::item::get_live_revision \
                                    -item_id $file_id]
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
        ns_write "[_ lorsm.Done]<hr>"
    }
    return $man_id
}
