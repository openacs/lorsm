# Put the current revision's attributes in a onerow datasource named "content".
# The detected content type is "content_revision".

lorsm::get_content content_revision

if { [info exists content(item_id)] } {
    if { ![string equal -length 4 "text" $content(mime_type)] } {
	# It's a file.
	cr_write_content -revision_id $content(revision_id)
	ad_script_abort
    } elseif { [string equal "text/css" $content(mime_type)]} {
	# we treat CSS files as if they would be binaries and deliver
	# them straight to the browser (maybe we should do the same
	# thing for XML files (?)
	cr_write_content -revision_id $content(revision_id)
    }


    # Ordinary text/* mime type.
    template::util::array_to_vars content



    set text [cr_write_content -string -revision_id $revision_id]

    if { ![string equal "text/html" $content(mime_type)] &&  ![string equal "text/xml" $content(mime_type)] } {
	set text [ad_html_text_convert -from $mime_type -to text/html $text]
    }
}

set imsitem_id [lorsm::get_ims_item_id] 

# We set all this blank variables in the case that the ims_item does
# not have a resource id

set title ""
multirow create children child_item_id child_title
set parent_item ""
set community_url [dotlrn_community::get_community_url [dotlrn_community::get_community_id]]


# There are pages that are not necesarily part of one ims_item_id
# but are part of a particular resource. 
if { [info exists content(item_id)] } {
    set write_p [fs::item_editable_p -item_id $content(item_id)]
} else {
    # No content to edit
    set write_p 0
}

if {![empty_string_p $imsitem_id]} {
    # See if they have write and the object is browser editable to offer an edit link.
    set write_p [permission::write_permission_p -object_id $imsitem_id] 
    if { $write_p && [info exists content(item_id)] } {
	set write_p [fs::item_editable_p -item_id $content(item_id)]
    } else {
	# No content to edit
	set write_p 0
    }

    set package_id [ad_conn package_id]
    set package_url [apm_package_url_from_id $package_id]

    set man_id [db_string man_id "select man_id from ims_cp_items i, ims_cp_organizations o where i.item_id = :imsitem_id and i.org_id = o.org_id"]
    set folder_id [db_string man_id "select folder_id from ims_cp_manifests where man_id = :man_id"]

    # We display children
    db_1row item_info "select title, parent_item from ims_cp_items where item_id = :imsitem_id"

    # Selected fields are renamed to avoid conflict with existing variables
    db_multirow -extend {href} children children {
	select 
	  ims_cp_items.item_id as child_item_id, 
	  ims_cp_items.title as child_title 
	from 
	  acs_objects,
	  ims_cp_items
	where 
	  acs_objects.object_id = ims_cp_items.item_id and
	  parent_item = :imsitem_id
	order by
	  acs_objects.object_id,
	  acs_objects.tree_sortkey
    } {
    
	# Let record-view display the page
	set href ${package_url}delivery/record-view
	set href "[export_vars -base $href \
			 -url {man_id}]&item_id=$child_item_id"
	
    }

    # See if this item only has one child, if so, load that instead
    if { [template::multirow size children] == 1 &&
	 [db_string grandchildren "
	     select count(*)
	       from ims_cp_items
	      where parent_item = [template::multirow get children 1 child_item_id]
	 "] == 0 } {
	set href ${package_url}delivery/record-view
	set href "[export_vars -base $href \
			 -url {man_id}]&item_id=[template::multirow get children 1 child_item_id]"
	ad_returnredirect $href
	ad_script_abort
    }

    if { [exists_and_not_null parent_item] } {

	# See if the parent has a resource mapped, if none, then this is a
	# top leve item, send it to the welcome page

	# Also, see if item is a lone leaf node, if so, the parent was
	# probably skipped and the grandparent link should be used
	# instead

	# See if I'm a leaf node first
	if { [template::multirow size children] == 0 } {
	    # Now see if I'm a lone leaf node
	    if { [db_string siblings {
		select count(*)
		  from ims_cp_items 
		 where parent_item = :parent_item}] == 1 } {
		# I'm a lone leaf, go to grandparent if it exists
		# Join to resources just to make sure it exists and
		# get href while we're at it, might be useful
		db_0or1row grandparent {
		    select
		      ims_cp_items.parent_item as grandparent_item,
		      ims_cp_resources.href as grandparent_href
		    from 
		      ims_cp_items, 
		      ims_cp_resources,
		      ims_cp_items_to_resources
		    where
		      ims_cp_items.item_id = :parent_item and
		      ims_cp_items.parent_item = ims_cp_items_to_resources.item_id and
		      ims_cp_items_to_resources.res_id = ims_cp_resources.res_id
		}
	    }
	}

	if { [db_0or1row href "select href as parent_href from ims_cp_resources r, ims_cp_items_to_resources ir where ir.item_id = :parent_item and ir.res_id = r.res_id"] || [info exists grandparent_item] } {
	    # Let record-view render this page so the child items are
	    # shown
	    set parent_href ${package_url}delivery/record-view
	    set parent_href "[export_vars -base $parent_href {man_id}]&item_id=[expr {"[info exists grandparent_item]"?$grandparent_item:$parent_item}]"
	} else {
	    # Go to the welcome page
	    set parent_href [export_vars \
				 -base ${package_url}delivery/body \
				 -url {man_id}
			    ]
	}
    }

    ns_log Notice "Content root on lors-default.tcl: ims_item_id $imsitem_id --"
    set ims_id $imsitem_id
    set return_url "[export_vars -base ${package_url}delivery/ {man_id ims_id}]"
    set return_url "[export_vars -url {return_url}]"
} 

ad_return_template