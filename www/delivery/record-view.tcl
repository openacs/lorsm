# packages/lorsm/www/delivery4/record-view.tcl

ad_page_contract {

    records a view for this ims_cp_item and redirects to its url

    @author Deds Castillo (deds@i-manila.com.ph)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-07-04
    @arch-tag: a7aba567-c4c1-4f1c-b5f3-ebc1ab277515
    @cvs-id $Id$
} {
    item_id:integer,notnull
    man_id:integer,notnull
    lmsfinish:integer,optional
} -properties {
} -validate {
} -errors {
}

if { ! [info exists lmsfinish] } {
        set lmsfinish 0
}

set viewer_id [ad_conn user_id]
set views [views::record_view -object_id $item_id -viewer_id $viewer_id]
set ns_item_id $item_id
set revision_id $item_id
#we check for those "escaping" sessions without doing LMSFINISH
set currenttrackid [ad_get_client_property lorsm currenttrackid]
set lorsmstudenttrack [ad_get_client_property lorsm studenttrack]
set initedonpage [ad_get_client_property lorsm initedonpage]

if { $initedonpage!=0 && $initedonpage!=""  } {
    if { $lmsfinish > 0 } {
        ns_log warning  "SCORM : back to record view after lms finish,
                        but it hasn't worked!"
        ns_log warning  "SCORM : resetting all visiting parameters."
        ad_set_client_property lorsm studenttrack 0
        ad_set_client_property lorsm studenttrack ""
        ad_set_client_property lorsm currenttrackid ""
        ad_set_client_property lorsm initedonpage ""
    } else {
        ad_set_client_property lorsm studenttrack 0
        ns_log warning  "SCORM : new content item with still open course ???"
        ns_log warning  "SCORM : we call for LMSFinish in place of the \
                        content!!!!!!???"
        ad_returnredirect [export_vars -base lmsfinish {item_id man_id initedonpage} ]
    }
}

#set item_id [lorsm::delivery::get_item_id -revision_id $revision_id]

set folder_id [lorsm::delivery::get_folder_id_from_man_id -man_id $man_id]
set lors_root [lorsm::get_root_folder_id]
set folder_name [lorsm::delivery::get_folder_name -folder_id $folder_id]
set content_root [lorsm::delivery::get_item_id_from_name_parent \
                    -name $folder_name \
                    -parent_id $lors_root]

if {[empty_string_p $content_root]} {
    # This was uploaded with lorsm so we use the folder_id from the table
    set content_root [lorsm::delivery::get_folder_id_from_man_id -man_id $man_id]
}

set url2 $folder_name

# Get the href of the item
set href [lorsm::delivery::get_href -ims_item_id $revision_id]

# Get the item title
set item_title [lorsm::delivery::get_ims_item_title -ims_item_id $revision_id]
set cr_item_id [lors::cr::get_item_id -folder_id $content_root -name $href]

if { [empty_string_p $cr_item_id] } {
    set res_id [lorsm::delivery::get_res_id -ims_item_id $revision_id]

    if { ![empty_string_p $res_id] } {
        set file_id [lorsm::delivery::get_file_id -res_id $res_id]
        if { [empty_string_p $file_id]} {
            set cr_item_id ""
        } else {
            set cr_item_id [lorsm::delivery::get_item_id -revision_id $file_id]
        }
    } else {
        set cr_item_id ""
    }
}

# get already imported data (like an assessment)
# it normally points relatively to the correct location in some parent folder
if {[regexp {^\.\.} $href]} {
    ad_returnredirect $href
}

# If no cr_item_id, this item is probably a folder
# Else deliver the page

if { ![empty_string_p $cr_item_id] } {
    # we check if the user has access right to the item
    #we analize now prerequisites. - the logic is identical  to menu.

    set community_id [dotlrn_community::get_community_id]
    set user_id [ad_conn user_id]

    db_1row getitemattributes {}

    #regsub -all {&} $prerequisites " " prerequisites
    regsub -all {[\{\}]} $prerequisites "" prerequisites
    regsub -all { & } $prerequisites " " prerequisites
    set prerequisites_list [split $prerequisites]

    foreach prer $prerequisites_list {
        if { ! [empty_string_p $prer]  } {
            ns_log warning "MENU prerequisites for $item_id are $prer "
            #in the following query we disregard the organization
            if { ! [ db_0or1row givemeid {} ] } {
                ns_log warning  "RECORD_VIEW: prerequisites not found comm: \
                                $community_id, man: $man_id, item: $item_id"
                continue
            } else {
                ns_log debug "RECORD_VIEW: THE REQUIRED ITEM IS $id_from_ref "
            }
        }

        if { ![empty_string_p $id_from_ref] } {
            ns_log warning "RECORD_VIEW: prerequisites for $item_id are $id_from_ref"
            if { ! [ db_0or1row isanysuspendedsession {} ] } {
                    ns_log warning "RECORD_VIEW: NOT FOUND TRACK"
                    append errormessage "Not attempted : $id_from_ref_title ($id_from_ref)"
                    append errormessage "<BR>"
                    ns_log warning $errormessage
            } else {
                switch -regexp $lex_status {
                    "^passed$" {
                        ns_log warning "ITEM ID $id_from_ref HAS A TRACK WITH $lex_status"

                    } "^completed$" {
                        ns_log warning "ITEM ID $id_from_ref HAS A TRACK WITH $lex_status"

                    } default {
                        ns_log warning "ITEM ID $id_from_ref HAS A TRACK WITH $lex_status"
                        append errormessage "$lex_status : $id_from_ref_title ($id_from_ref)"
                        append errormessage "<BR>"
                        ns_log warning $errormessage
                    }
                }
             }
            #if found session for id_from_ref
        }
        #if found id_from_ref
    }
    #foreach close

    if { [info exists errormessage] } {
        ns_log warning $errormessage
        append message \
            "<html>
                <head>
                    <title></title>
                    <link rel=\"stylesheet\" type=\"text/css\"
                        href=\"/resources/dotlrn/dotlrn-master.css\" media=\"all\">
                </head>
                <body border=1>
                    <center><H1><B> $item_title : </H1></p><br>
                    <center> Please first complete following items : </p><br>" \
            $errormessage

        ns_return 200 text/html $message
        ad_script_abort
    }

    # This is the revision of the file (html, jpg, etc)
    set cr_revision_id [item::get_best_revision $cr_item_id]
    set cr_item_mime [item::get_mime_info $cr_revision_id mime_info]

    if { ![string equal -length 4 "text" $mime_info(mime_type)] || \
            [string equal "text/xml" $mime_info(mime_type)]} {
        # It's a binary or XML file.
        ns_log debug "BINARY/XML FILE FROM RECORD VIEW"
        ns_log debug    "lorsm - (SCORM) record-view - TEXT - it's a file.
                        should we get an error?"
        cr_write_content -revision_id $cr_revision_id
        ad_script_abort

    } else {
        # It's a textual/xml file.
        set href "$url2/$href"
        regsub -all {//} $href {/} href
        set ims_item_id $cr_revision_id

        # lorsm::set_content_root content_root
        lorsm::set_ims_item_id $item_id

        ns_log debug    "SCORM record-view : TEXT - $href cr_item_id
                        $cr_item_id item_id $item_id ims_item_id
                        $ims_item_id revision_id $revision_id "

        ad_set_client_property lorsm ims_id $item_id
        #ad_set_client_property lorsm ims_id $revision_id

        # we use nsv variables to set the delivery environment this is a
        # temporary solution until we find something a bit better

        if {[nsv_exists delivery_vars [ad_conn session_id]]} {
            nsv_unset delivery_vars [ad_conn session_id]
        }

        #the delivery environment is passed to view/index.vuh which fetches
        #everything from content repository

        nsv_set delivery_vars [ad_conn session_id] [list]
        nsv_lappend delivery_vars [ad_conn session_id] $content_root
        nsv_lappend delivery_vars [ad_conn session_id] $item_id

        ad_returnredirect [export_vars -base view/$href {ims_item_id} ]
        ad_script_abort
    }
} else {
    lorsm::set_ims_item_id $item_id

    ns_log debug    "lorsm - (SCORM) record-view - EMPTY CR_ITEM_ID -
                    cr_item_id $cr_item_id item_id $item_id"
    ad_set_client_property lorsm ims_id $item_id

    # We have no content, so wipe item_id from the lorsm namespace
    # This fixes a strange bug if you click a 'no content' menu item
    # repeatedly and different content appears!

    if { [info exists lorsm::item_id] } {
        set lorsm::item_id ""
    }
    rp_internal_redirect -absolute_path [acs_root_dir]/templates/lorsm-default
}
