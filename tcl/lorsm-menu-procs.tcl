# packages/lorsm/tcl/lorsm-menu-procs.tcl

ad_library {
    
    Functions for generating menu links
    
    @author Roel Canicula (roelmc@pldtdsl.net)
    @creation-date 2005-03-16
    @arch-tag: 46f6be1c-68ad-4dfb-bfbe-ba9b504e316f
    @cvs-id $Id$
}

namespace eval lorsm::menu {

    ad_proc -public leftnav {
	user_id
	community_id
    } {
	Return leftnav items
	
	@author Roel Canicula (roelmc@pldtdsl.net)
	@creation-date 2005-03-16
	
	@user_id

	@community_id

	@return 
	
	@error 
    } {
	set items [list]
	set new_items [list]
	set previous -1

	if {![empty_string_p $community_id]} {
	    set community_url [dotlrn_community::get_community_url $community_id]
	    set lorsm_url "${community_url}lorsm"
	    set package [site_node::get_object_id -node_id [site_node::get_element -url ${lorsm_url} -element node_id]]

	    set member_p [dotlrn_community::member_p $community_id $user_id]
	    set admin_p [dotlrn::user_can_admin_community_p -user_id $user_id -community_id $community_id]
	    if {$member_p || $admin_p} {
		set portal_id [dotlrn_community::get_portal_id \
				   -community_id $community_id
			      ]
	    } else {
		# show this person the comm's non-member-portal
		set portal_id [dotlrn_community::get_non_member_portal_id \
				   -community_id $community_id
			      ]
	    }

	    array set _folders [list {Course Information} {#dotlrn-fs.Additional_Info#} {Course Content} {#dotlrn-fs.Additional_Content#} Resources {#dotlrn-fs.Additional_Resources#}]

	    foreach folder [array names _folders] {
		set fs_link $_folders($folder)
		
		# Check if portal page with the same name exists
		# Can't use portal::get_page_id coz that'll create a portal
		# page if it doesn't exist
		if { [db_0or1row portal_page {
		    select page_id, sort_key
		    from portal_pages
		    where portal_id = :portal_id
		    and pretty_name = :fs_link
		}] } {
		    # Check if the fs folder exists
		    if { [db_0or1row folder {
			select m.element_id, value as folder_id, p.page_id as current_page_id
			from portal_element_parameters ep,
			portal_element_map m,
			portal_pages p
			where ep.element_id = m.element_id
			and m.page_id = p.page_id
			and p.portal_id = :portal_id
			and ep.key = 'folder_id'
			and m.pretty_name = :fs_link
			
			limit 1
		    }] } {
			# If portlet isn't in the right page, place it there
			if { $page_id != $current_page_id } {
			    db_dml update_portlet {
				update portal_element_map
				set page_id = :page_id,
				state = 'full'
				where element_id = :element_id
			    }
			}
			
			# Folder exists, see if it has contents
			set folder_contents [fs::get_folder_contents -folder_id $folder_id -user_id $user_id]
			
			if { [llength $folder_contents] > 0 } {
			    set folders($folder) [list $fs_link $sort_key]
			}
		    }
		}
	    }

	    db_foreach mans {
		select 
		cp.man_id, cp.fs_package_id, cp.folder_id
		from
		ims_cp_manifests cp, 
                -- acs_objects acs, 
                ims_cp_manifest_class cpmc
		where 
		-- cp.man_id = acs.object_id
		-- and
		cp.man_id = cpmc.man_id
		and
		--	   acs.context_id = :package
		cpmc.lorsm_instance_id = :package
		and
		cpmc.isenabled = 't'
		order by cp.man_id desc -- acs.creation_date desc
	    } {
		foreach org_id [db_list organizations {
		    select 
		    org.org_id,
		    org.org_title as org_title,
		    org.hasmetadata,
		    tree_level(cr.tree_sortkey) as indent
		    from
		    ims_cp_organizations org,
                    -- acs_objects o
		    cr_items cr
		    where
		    cr.item_id = ( select item_id from cr_revisions where revision_id = org.org_id)
		    and
		    man_id = :man_id
		    order by
		    org_id
		}] {
		    set items_list [list]

		   set indent_list [lorsm::get_items_indent -org_id $org_id]		    
		    template::util::list_of_lists_to_array $indent_list indent_array
		    db_foreach sql {		   
			SELECT
			i.ims_item_id as item_id,
			i.item_title as item_title
			FROM 
                        ims_cp_items i
			WHERE 
			i.org_id = :org_id

			AND
			EXISTS
			(select 1
			 from acs_object_party_privilege_map p
			 where p.object_id = i.ims_item_id 
			 and p.party_id = :user_id
			 and p.privilege = 'read')
			
			ORDER BY 
			i.ims_item_id --, tree_sortkey
		    } {
# FIXME DAVEB I think this is rather fragile, but it seems to be working right now to set the indent. I guess we need to really have the indent of the org_id item as well
			set indent [expr $indent_array($item_id) -1 ]
set item_url [export_vars -base "${lorsm_url}/delivery3/record-view" {man_id item_id}]
lappend items [list url $item_url man_id $man_id id $item_id title $item_title indent $indent previous $previous fs_package_id $fs_package_id folder_id $folder_id org_id $org_id]
			set previous $indent
		    }
		}
	    }

	    set i 0
	    set additional_item [list]
	    foreach _item $items {
		array set item $_item

		set content_root [fs::get_root_folder -package_id $item(fs_package_id)]
		set item_id $item(id)
		set folder_id $item(folder_id)
		
		set url2 "[db_string select_folder_key {select key from fs_folders where folder_id = :folder_id}]/"
		
		set href [db_string href "select href from ims_cp_resources r, ims_cp_items_to_resources ir where ir.ims_item_id = :item_id and ir.res_id = r.res_id" -default ""]
		
		set fs_item_id [fs::get_item_id -folder_id $folder_id -name $href]
		
		set mime_type ""
		if { ! [empty_string_p $fs_item_id] } {
		    set fs_revision_id [item::get_best_revision $fs_item_id]
		    set fs_item_mime [item::get_mime_info $fs_revision_id mime_info]
		    set mime_type $mime_info(mime_type)
		}

		if { $item(previous) > $item(indent) && [llength $additional_item] > 0 } {
		    #set items [linsert $items $i $additional_item]
		    lappend new_items $additional_item
		    set additional_item [list]
		    #incr i
		}

		if { [info exists folders($item(title))] && $item(indent) == 0 } {
		    set additional_item [list url [export_vars -base [dotlrn_community::get_community_url $community_id] {{page_num "[lindex $folders($item(title)) 1]"}}] man_id $man_id id 0 title [lindex $folders($item(title)) 0] indent 1 previous $item(indent)]
		}

		incr i
		set previous $indent

		lappend _item mime_type $mime_type
		lappend new_items $_item
	    }
	}

	return $new_items
	
    }

}