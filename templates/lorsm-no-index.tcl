# Put the current revision's attributes in a onerow datasource named "content".
# The detected content type is "content_revision".

lorsm::get_content content_revision
set user_id [ad_conn user_id]

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
		set item_list [lorsm::get_item_list $man_id $user_id]
		set litem_list [llength $item_list]

		if { ![expr $litem_list - [lsearch -exact $item_list $viewed_item_id] -1] } {
			# last item, it's a special case
			set last_item_viewed [db_string select_last_item_viewed {    
				select item_id
				from views v,
				ims_cp_items i,
				ims_cp_organizations o
				where v.viewer_id = :user_id
				and v.object_id = i.item_id
				and i.org_id = o.org_id
				and o.man_id = :man_id
				order by v.last_viewed desc
				limit 1
			} -default "no item"]
			if { !([lsearch -exact [lrange $item_list [expr $litem_list - 2] $litem_list] $last_item_viewed] != -1) && ![string eq $last_item_viewed "no item"] } {
				set viewed_item_id [lindex $item_list [expr [lsearch -exact $item_list $viewed_item_id] - 1]]
			}
		} else {
			set viewed_item_id [lindex $item_list [expr [lsearch -exact $item_list $viewed_item_id] - 1]]
		}
		lorsm::record_view $viewed_item_id $man_id

		# Student tracking
		set package_id [ad_conn package_id]
		set community_id [dotlrn_community::get_community_id]
		
		if {[lorsm::track::istrackable -course_id $man_id -package_id $package_id]} {
			
			set track_id [lorsm::track::new \
							  -user_id $user_id \
							  -community_id $community_id \
							  -course_id $man_id]
			lorsm::track::exit -track_id $track_id
		}

		# refresh the page every 300 seconds so we can have an estimate of the time when the user viewed the course for the last time
		if { ![regsub -nocase {<\/head>} $text {
			<meta http-equiv="refresh" content="300">
			</head> 
		} text] } {
			regsub -nocase {<html>} $text {
				<html>
				<head>
				<meta http-equiv="refresh" content="300">
				</head> 
			} text
		}
	}

	# parent window
 	regsub -all -nocase {target=[^ |^>]+} $text {target="_parent"} text


}

ad_return_template
