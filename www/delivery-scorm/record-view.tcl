# packages/lorsm/www/delivery4/record-view.tcl

ad_page_contract {
    
    records a view for this ims_cp_item and redirects to its url
    
    @author Deds Castillo (deds@i-manila.com.ph)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-07-04
    @arch-tag: a7aba567-c4c1-4f1c-b5f3-ebc1ab277515
    @cvs-id $Id$
} {
    item_id:notnull
    man_id:notnull
} -properties {
} -validate {
} -errors {
}


set viewer_id [ad_conn user_id]

set views [views::record_view -object_id $item_id -viewer_id $viewer_id]

set ns_item_id $item_id
set revision_id $item_id

set item_id [lorsm::delivery::get_item_id -revision_id $revision_id]

set folder_id [lorsm::delivery::get_folder_id_from_man_id -man_id $man_id]
set lors_root [lorsm::get_root_folder_id]
set folder_name [lorsm::delivery::get_folder_name -folder_id $folder_id]
set content_root [lorsm::delivery::get_item_id_from_name_parent -name $folder_name -parent_id $lors_root]

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

    # This is the revision of the file (html, jpg, etc)
    set cr_revision_id [item::get_best_revision $cr_item_id]
    set cr_item_mime [item::get_mime_info $cr_revision_id mime_info]

 
   if { ![string equal -length 4 "text" $mime_info(mime_type)] } {
	# It's a file.
    ns_log debug "lorsm - (SCORM) record-view - TEXT - it's a file. should we get an error?"
	cr_write_content -revision_id $cr_revision_id
	ad_script_abort

    } else {
	
	set href "$url2/$href"
	regsub -all {//} $href {/} href
	set ims_item_id $cr_revision_id
	
	# lorsm::set_content_root content_root
	lorsm::set_ims_item_id $item_id

    ns_log debug "lorsm - (SCORM) record-view - NOT TEXT -  cr_item_id $cr_item_id item_id $item_id ims_item_id $ims_item_id revision_id $revision_id "
    ad_set_client_property lorsm ims_id $revision_id

	# we use nsv variables to set the delivery environment this is a
	# temporary solution until we find something a bit better

	if {[nsv_exists delivery_vars [ad_conn session_id]]} {
	    nsv_unset delivery_vars [ad_conn session_id]
	}


	nsv_set delivery_vars [ad_conn session_id] [list]

	nsv_lappend delivery_vars [ad_conn session_id] $content_root
	ad_returnredirect [export_vars -base view/$href {ims_item_id} ]
	ad_script_abort
    }
} else {
    lorsm::set_ims_item_id $item_id

    ns_log debug "lorsm - (SCORM) record-view - EMPTY CR_ITEM_ID - cr_item_id $cr_item_id item_id $item_id"
    ad_set_client_property lorsm ims_id $item_id

    # We have no content, so wipe item_id from the lorsm namespace
    # This fixes a strange bug if you click a 'no content' menu item
    # repeatedly and different content appears!
    if { [info exists lorsm::item_id] } {
	set lorsm::item_id ""
    }
    rp_internal_redirect -absolute_path [acs_root_dir]/templates/lorsm-default
}
