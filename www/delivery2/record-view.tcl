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

set revision_id [item::get_best_revision $item_id]

db_1row manifest_info "select fs_package_id, folder_id from ims_cp_manifests where man_id = :man_id"
set content_root [fs::get_root_folder -package_id $fs_package_id]

set url2 "[db_string select_folder_key {select key from fs_folders where folder_id = :folder_id}]/"

set href [db_string href "select href from ims_cp_resources r, ims_cp_items_to_resources ir where ir.item_id = :item_id and ir.res_id = r.res_id" -default ""]

db_1row item_info "select title from ims_cp_items where item_id = :item_id"

set fs_item_id [fs::get_item_id -folder_id $folder_id -name $href]

# If no fs_item_id, this item is probably a folder
# Else deliver the page
if { ![empty_string_p $fs_item_id] } {

    set fs_revision_id [item::get_best_revision $fs_item_id]
    set fs_item_mime [item::get_mime_info $fs_revision_id mime_info]


    if { ![string equal -length 4 "text" $mime_info(mime_type)] } {

	# It's a file.
	cr_write_content -revision_id $fs_revision_id
	ad_script_abort

    } else {
	
	set href $url2$href
	regsub -all {//} $href {/} href
	set imsitem_id $item_id

	#    lorsm::set_content_root content_root
	lorsm::set_ims_item_id $item_id

	# we use nsv variables to set the delivery environment this is a
	# temporary solution until we find something a bit better

	if {[nsv_exists delivery_vars [ad_conn session_id]]} {
	    nsv_unset delivery_vars [ad_conn session_id]
	}

	nsv_set delivery_vars [ad_conn session_id] [list]

	nsv_lappend delivery_vars [ad_conn session_id] $content_root

	ad_returnredirect [export_vars -base ../delivery/view/$href {imsitem_id} ]
    }
} else {
    lorsm::set_ims_item_id $item_id
    
    # We have no content, so wipe item_id from the lorsm namespace
    # This fixes a strange bug if you click a 'no content' menu item
    # repeatedly and different content appears!
    if { [info exists lorsm::item_id] } {
	set lorsm::item_id ""
    }

    rp_internal_redirect -absolute_path [acs_root_dir]/templates/lorsm-default
}
