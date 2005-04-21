# Put the current revision's attributes in a onerow datasource named "content".
# The detected content type is "content_revision".

lorsm::get_content content_revision

if { [info exists content(item_id)] } {
    if { ![string equal -length 4 "text" $content(mime_type)] } {
		# It's a file.
		cr_write_content -revision_id $content(revision_id)
		ad_script_abort
	} elseif { [string equal "text/css" $content(mime_type)] || [string equal "text/xml" $content(mime_type) ]} {
		# we treat CSS files as if they would be binaries and deliver
		# them straight to the browser (maybe we should do the same
		# thing for XML files (?)
		cr_write_content -revision_id $content(revision_id)
		ad_script_abort
    }
	

    # Ordinary text/* mime type.
    template::util::array_to_vars content
	
    set text [cr_write_content -string -revision_id $revision_id]
	
    if { ![string equal "text/html" $content(mime_type)] || ![string equal "text/xml" $content(mime_type)]} {
		set text [ad_html_text_convert -from $mime_type -to text/html $text]
    }
}

if { [string eq $content(mime_type) "text/html"] && [regexp -nocase {<html>} $text match] } {
		
	if { [db_0or1row get_imsitem_id {
		select map.item_id as viewed_item_id, o.man_id
		from ims_cp_items_to_resources map, ims_cp_files f, ims_cp_organizations o, ims_cp_items i
		where f.file_id = :item_id
		and f.res_id = map.res_id
		and map.item_id = i.item_id 
		and i.org_id = o.org_id
	}] } {
		# record view
		set item_list [lorsm::get_item_list $man_id [ad_conn user_id]]
		set viewed_item_id [lindex $item_list [expr [lsearch -exact $item_list $viewed_item_id] - 1]]
		lorsm::record_view $viewed_item_id $man_id
	}

	# parent window
 	regsub -all -nocase {target=[^ |^>]+} $text {target="_parent"} text
}

ad_return_template
