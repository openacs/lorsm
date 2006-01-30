# packages/lorsm/tcl/lorsm-procs.tcl

ad_library {
    
    LORS Management Procedures
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-16
    @arch-tag daf81eac-5543-4f92-b06a-547313205683
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

namespace eval lorsm {

variable item_id
variable item_url
variable template_url
variable revision_id

variable content_root
variable ims_item_id
variable ims_item_title
variable ims_man_id

    ad_proc -public fix_url {
	-url:required
    } {
	Function use to fix URLs for course that use whitespaces for their directories,
	since the file-storage renames the directories and put a _ instead of a whitespace.
	This function should be gone when the file-storage can add folders with whitespaces.
	
	@param url The identifier reference that we need to modify.
	@author Ernie Ghiglione (ErnieG@mm.st)
	
    } {
	set filename [file tail $url]
	
	if {!([string length $filename] == [string length $url])} {
	    
	    set path [string trimright $url $filename]
	    regsub -all { } $path {_} newpath
	    return $newpath$filename
	} else {
	    return $url
	}
    }

    ad_proc -public fix_href {
	-item_title:required
	-identifierref:required
	-fs_package_id:required
	-fs_local_package_id:required
	-folder_id:required
	-type:required
	-track_id:required
    } {
	Function use to fix the HREF of resources.
	It could be that the reference to a resource is outside the 
	scope of the learning object (somewhere on the web) instead
	of a file or resource in the course. 

	Therefore, this function determines whether ther link to the
	resource is within the course materials. If that is the case
	it created the link to where the file is stored in the file-
	storage. Otherwise, if the resource needs to be fetched from
	the web (http://) then we use that href instead.
	
	@param item_title The title of the item in question
	@param identifierref The resource's identifierref 
	@param fs_package_id the file-storage package id
	@param fs_local_package_id the local file-storage package id
	@param folder_id file-storage folder id
	@param type type of resource
	@param track_id whether the ims_cp_item should be tracked or not.
	@author Ernie Ghiglione (ErnieG@mm.st)
	
    } {

	if {![empty_string_p $identifierref]} {
	    
	    if {[regexp "http://" $identifierref]} {
		
		return "<a href=\"$identifierref\" target=\"body\">$item_title</a>"

	    } else {

		switch $type {
		    "ims-qti-package" {
			set url "<a href=\"$identifierref\" target=\"body\">$item_title</a>"

		    }
		    default {

			set url1 "[apm_package_url_from_id $fs_local_package_id]view/"
			set url2 "[db_string select_folder_key {select key from fs_folders where folder_id = :folder_id}]"
			set url3 [lorsm::fix_url -url $identifierref]
			set content_root [fs::get_root_folder -package_id $fs_package_id]
			set url "<a href=\"[export_vars -base $url1$url2/$url3 {content_root}]\" target=\"body\">$item_title</a>"
		    }
		}


		return $url
	    }
	
	} else {
	    return $item_title
	}

    }

    ad_proc -public get_course_name {
	-manifest_id:required
    } {
	Given a man_id, it returns the name of the course

	@param manifest_id the Id for the course
	@author Ernie Ghiglione (ErnieG@mm.st)
    } {

	return [db_string course_name {select course_name from ims_cp_manifests where man_id = :manifest_id}]

    }

    ad_proc -public dates_calc {
	-start_date:required
	-end_date:required
    } {
	Returns the number of minutes, hours or dates given a start
	and end date. 

	@param start_date Starting date
	@param end_date   Ending date
	@author Ernie Ghiglione (ErnieG@mm.st)
    } {

	set start [clock scan "$start_date"]
	set end   [clock scan "$end_date"]

	set difference [expr {$end - $start}]
	
	if {$difference >= 0 && $difference < 60} {
	    return "[_ lorsm.difference_seconds]"
	} elseif {$difference >= 60 && $difference < 3600} {
	    set tempval [expr {$difference / 60.0}]
	    return "[_ lorsm.tempval_minutes]"

	} elseif {$difference >= 3600 && $difference < 86400} {
	    set tempval [expr {$difference / 60.0 /60.0 }]
	    return "[_ lorsm.tempval_hours]"

	} else {
	    set tempval [expr {$difference / 60.0 / 60.0 / 24.0}]
	    return "[_ lorsm.tempval_days]"
	}
    }


    ad_proc -public fix_href2 {
	-item_id:required
	-identifierref:required
	-fs_package_id:required
	-fs_local_package_id:required
	-folder_id:required
	-type:required
	-track_id:required
    } {
	Function use to fix the HREF of resources.
	It could be that the reference to a resource is outside the 
	scope of the learning object (somewhere on the web) instead
	of a file or resource in the course. 

	Therefore, this function determines whether ther link to the
	resource is within the course materials. If that is the case
	it created the link to where the file is stored in the file-
	storage. Otherwise, if the resource needs to be fetched from
	the web (http://) then we use that href instead.
	
	@param item_title The title of the item in question
	@param identifierref The resource's identifierref 
	@param fs_package_id the file-storage package id
	@param fs_local_package_id the local file-storage package id
	@param folder_id file-storage folder id
	@param type type of resource
	@param track_id whether the ims_cp_item should be tracked or not.
	@author Ernie Ghiglione (ErnieG@mm.st)
	
    } {


	if {![empty_string_p $identifierref]} {
	        
	    # if the href is already a link to another site, then just
	    # let it be that
	    if {[regexp "http://" $identifierref]} {
		set identifierref $identifierref
	    } else {
		# otherwise, let the fun begin!
		# we need to construct the right URL for this item and
		# the instance of the class that is trying to deploy
		# it. Further explanation in the documentation.
		switch $type {
		    default {
			set url1 "[apm_package_url_from_id $fs_local_package_id]view/"
			set folder_id $folder_id
			set url2 "[db_string select_folder_key {select key from fs_folders where folder_id = :folder_id}]/"
			set url3 [lorsm::fix_url -url $identifierref]
			set content_root [fs::get_root_folder -package_id $fs_package_id]
			set item_id $item_id
			set identifierref [export_vars -base [concat $url1$url2$url3] {content_root}] 

			# if the course is trackable, we need to make
			# sure we record the items the user has
			# seen. These are ims_items type of objects
			if {$track_id != 0} {

			    set redirect_url $identifierref
			    set identifierref [export_vars -base record-view {item_id}]

			}
		    }
		}
	    }
	    return $identifierref
	} else {
	    return ""
	}

    }



### Testing ground

    ad_proc -public fix_href3 {
	-man_id:required
	-item_id:required
	-identifierref:required
	-fs_package_id:required
	-fs_local_package_id:required
	-folder_id:required
	-type:required
	-track_id:required
    } {
	Function use to fix the HREF of resources.
	It could be that the reference to a resource is outside the 
	scope of the learning object (somewhere on the web) instead
	of a file or resource in the course. 

	Therefore, this function determines whether ther link to the
	resource is within the course materials. If that is the case
	it created the link to where the file is stored in the file-
	storage. Otherwise, if the resource needs to be fetched from
	the web (http://) then we use that href instead.
	
	@param man_id manifest Id
	@param item_title The title of the item in question
	@param identifierref The resource's identifierref 
	@param fs_package_id the file-storage package id
	@param fs_local_package_id the local file-storage package id
	@param folder_id file-storage folder id
	@param type type of resource
	@param track_id whether the ims_cp_item should be tracked or not.
	@author Ernie Ghiglione (ErnieG@mm.st)
	
    } {

	if {![empty_string_p $identifierref]} {
	        
	    # if the href is already a link to another site, then just
	    # let it be that
	    if {[regexp "http://" $identifierref]} {
		set identifierref $identifierref
	    } else {
		# otherwise, let the fun begin!
		# we need to construct the right URL for this item and
		# the instance of the class that is trying to deploy
		# it. Further explanation in the documentation.
		switch $type {
		    default {
			set url1 "view/"
#CM creating url2 in record-view
#			set folder_id $folder_id
#			set url2 "[db_string select_folder_key {select key from fs_folders where folder_id = :folder_id}]/"
#CM Not using url3 anymore
#			set url3 [lorsm::fix_url -url $identifierref]
			set content_root [fs::get_root_folder -package_id $fs_package_id]
			set item_id $item_id
#			set identifierref [export_vars -base record-view {content_root url2 url3 item_id man_id}] 
			set identifierref [export_vars -base record-view {item_id man_id content_root}] 

			# if the course is trackable, we need to make
			# sure we record the items the user has
			# seen. These are ims_items type of objects
			if {$track_id != 0} {

#			    set redirect_url $identifierref
#			    set identifierref [export_vars -base record-view {redirect_url item_id}]

			}
		    }
		}
	    }
	    return $identifierref
	} else {
	    return ""
	}
	
    }

ad_proc -public set_ims_item_id { ims_it_id } {
    
    variable ims_item_id $ims_it_id
}

ad_proc -public get_ims_item_id { } {

    variable ims_item_id
    return $ims_item_id
 
}

ad_proc -public get_item_list { man_id user_id } {
	set item_list [list]
	db_foreach organizations {
		select 
		org.org_id,
		org.org_title as org_title,
		org.hasmetadata,
		tree_level(o.tree_sortkey) as indent
		from
		ims_cp_organizations org, acs_objects o
		where
		org.org_id = o.object_id
		and
		man_id = :man_id
		order by
		org_id
	} {

		db_foreach sql {		   
			SELECT
		        i.parent_item,
			i.ims_item_id,
			i.item_title as item_title
			FROM 
			acs_objects o, ims_cp_items i, cr_items cr
			WHERE 
			o.object_type = 'ims_item_object'
			AND
			i.org_id = :org_id
			AND
			o.object_id = i.ims_item_id
		        AND 
                        cr.item_id = ( select item_id from cr_revisions where revision_id = i.ims_item_id)
	                AND 
			EXISTS
			(select 1
			 from acs_object_party_privilege_map p
			 where p.object_id = i.ims_item_id 
			 and p.party_id = :user_id
			 and p.privilege = 'read')

			ORDER BY 
			i.sort_order, o.object_id, cr.tree_sortkey
		} {
			lappend item_list $ims_item_id
		}
	}
	return $item_list
}

ad_proc -public record_view { item_id man_id } {

	set viewer_id [ad_conn user_id]

	set views [views::record_view -object_id $item_id -viewer_id $viewer_id]

	set revision_id [item::get_best_revision $item_id]

	db_1row manifest_info "select fs_package_id, folder_id from ims_cp_manifests where man_id = :man_id"
	set content_root [fs::get_root_folder -package_id $fs_package_id]

	set url2 "[db_string select_folder_key {select key from fs_folders where folder_id = :folder_id}]/"

	set href [db_string href "select href from ims_cp_resources r, ims_cp_items_to_resources ir where ir.ims_item_id = :item_id and ir.res_id = r.res_id" -default ""]

	db_1row item_info "select item_title from ims_cp_items where ims_item_id = :item_id"

	set fs_item_id [fs::get_item_id -folder_id $folder_id -name $href]

	# If no fs_item_id, this item is probably a folder
	# Else deliver the page
	if { ![empty_string_p $fs_item_id] } {

		set fs_revision_id [item::get_best_revision $fs_item_id]
		set fs_item_mime [item::get_mime_info $fs_revision_id mime_info]
		
		
		if { [string equal -length 4 "text" $mime_info(mime_type)] } {
			
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
			
		}
	} else {
		lorsm::set_ims_item_id $item_id
		
		# We have no content, so wipe item_id from the lorsm namespace
		# This fixes a strange bug if you click a 'no content' menu item
		# repeatedly and different content appears!
		if { [info exists lorsm::item_id] } {
			set lorsm::item_id ""
		}
	}
	
}

ad_proc -public init { urlvar rootvar {content_root ""} {template_root ""} {context "public"} {rev_id ""} {content_type ""} } {

    upvar $urlvar url $rootvar root_path 
    
    variable ims_item_id
    variable revision_id
    
    # if a .tcl file exists at this url, then don't do any queries
    if { [file exists [ns_url2file "$url.tcl"]] } {
	return 0
    }
    
    # cache this query persistently for 1 hour
    # this is faster than 1 query because a pl/sql function in the
    # where clause is a very bad idea

    db_0or1row get_item_id ""
    db_0or1row get_item_type ""
    # No item found, so do not handle this request
    if { ![exists_and_not_null item_id] } { 

		db_0or1row get_template_info "" -column_array item_info
		
		if { ![info exists item_info] } { 
			ns_log warning "lorsm - init: no content found for url $url"
			return 0 
		}
    } 
    
    variable item_url
    set item_url $url

    if { [empty_string_p $content_type] } {
	set content_type $item_info(content_type)
    }
    
    ns_log debug "lorsm - init: urlvar rootvar rev_id item_id ims_item_id- $urlvar $rootvar $rev_id $item_id $ims_item_id"
    
    # Make sure that a live revision exists
    if { [empty_string_p $rev_id] } {
       set live_revision [db_string get_live_revision "" -default ""]
	if { [template::util::is_nil live_revision] } {
	    ns_log warning "lorsm - init: no live revision found for content item $item_id"
	    return 0
	}
	set revision_id $live_revision
    } else {
		set revision_id $rev_id
    }

    variable template_path
    
    # Get the template 
    set template_found_p [db_0or1row get_template_url "" -column_array info]
    
    if { !$template_found_p || [string equal $info(template_url) {}] } { 
	ns_log warning "lorsm - init: No template found to render content item $item_id in context '$context'"
	return 0
    }
    
    set url $info(template_url)
    set root_path [get_template_root]
    
    return 1
}

ad_proc -public get_template_root {} {

    # Look for package-defined root
    set package_id [ad_conn package_id]
    set template_root \
	[ad_parameter -package_id $package_id TemplateRoot dummy ""]
    
    if { [empty_string_p $template_root] } {
	# Look for template root defined in the CR
	set package_id [apm_package_id_from_key "acs-content-repository"]
	
	set template_root [ad_parameter -package_id $package_id \
			       TemplateRoot dummy "templates"]
    }
    
    if { [string index $template_root 0] != "/" } {
	# Relative path, prepend server_root
	set template_root "[acs_root_dir]/$template_root"
    }

    return [ns_normalizepath $template_root]
    
}


ad_proc -public get_content { { content_type {} } } {
 
    variable item_id
    variable revision_id
    variable ims_item_id
    variable ims_item_title
  

set item_id $ims_item_id
    if { [template::util::is_nil item_id] } {
	ns_log warning "lorsm - get_content: No active item in lorsm - get_content"
	return
    }


    # Get the live revision
    set revision_id [db_string get_revision ""]

    if { [template::util::is_nil revision_id] } {
	ns_log warning "lorsm - get_content: No live revision for item $item_id"
	return
    }

    # Get the mime type, decide if we want the text
    set mime_type [db_string get_mime_type ""]
  
    if { [template::util::is_nil mime_type] } {
	ns_log warning "lorsm - get_content: No such revision: $revision_id"
	return
    }  

    # Get the content type
    if { [empty_string_p $content_type] } {
	set content_type [db_string get_content_type ""]
    }

    upvar content content

    array set content "item_id $item_id revision_id $revision_id mime_type $mime_type content_type $content_type"
    
}


}

ad_proc -public lorsm::get_root_folder_id { } { } {
    return [db_string get_root_folder { select folder_id from cr_folders where label = 'LORSM Root Folder' } -default ""]
}    

ad_proc -public lorsm::get_folder_id { 
    -name:required
} {
    return [db_string get_root_folder { select folder_id from cr_folders where label = :name } -default ""]
}    

ad_proc -public lorsm::get_items_indent {
   -org_id:required
} {
    Returns a list of the form \{ims_item_id indent\} from one org_id
} {

    # We need all the count of all items (just live revisions)
    set items_count [db_string get_items_count { select count(ims_item_id)
	from ims_cp_items where ims_item_id in ( select live_revision
						 from cr_items where content_type = 'ims_item_object') and
	org_id = :org_id
    }]
    
    # Get the root items
    set count 0
    db_foreach get_root_item { select ims_item_id from ims_cp_items where parent_item = :org_id and org_id = :org_id } {
	lappend items_list [list $ims_item_id 1]
	set items_array($ims_item_id) 1
	incr count
    }

    
    while { $count < $items_count } {
	foreach item $items_list {
	    set item_id [lindex $item 0]
	    set indent [expr [lindex $item 1] + 1]
	    db_foreach get_items {select ims_item_id from ims_cp_items where parent_item = :item_id and org_id = :org_id } {
		if { ![info exist items_array($ims_item_id)] } {
		    lappend items_list [list $ims_item_id $indent]
		    set items_array($ims_item_id) $indent
		    incr count
		}
	    }
	}
    }
    return $items_list
}

ad_proc -public lorsm::get_item_delivery_url {
    -man_id:required
    -item_id:required
    -community_id
} {
     Get delivery URL
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-03-30
    
    @param man_id

    @param item_id

    @return 
    
    @error 
} {
    set base_url ""
    if {[exists_and_not_null community_id]} {
        append base_url "FIXME"
    }
    set url [export_vars -base ${base_url}lorsm {man_id item_id}]
    return $url
}

ad_proc -public lorms::imscp::register_xml_object_id {
    {-xml_file:required}
    {-community_id:required}
} {
    Relation with lorsm of IMSCP files returning the object_id

} {
    # Save the current package_id to restore when the object is
    # imported
    set current_package_id [ad_conn package_id]
    # Get the package_id associated with the current community
    # FIXME this is a hack until I figure out how to get the
    # package_id of the current community
    ad_conn -set package_id [db_string get_package_id {select dotlrn_community_applets.package_id from dotlrn_community_applets join apm_packages on (dotlrn_community_applets.package_id=apm_packages.package_id) where community_id = :community_id and package_key='lorsm'}]
    
    set object_id [lorsm::imscp::import_imscp $xml_file]

    # Restore the package_id
    ad_conn -set package_id $current_package_id
   
    return $object_id
}

