# packages/lorsm/www/delivery/menu-mk.tcl

ad_page_contract {
    
    Course Delivery Table of Content
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-09
    @arch-tag 553390f0-450e-48db-99f0-c5dcb17978b8
    @cvs-id $Id$
} {
    man_id:integer,notnull  
    ims_id:integer,notnull,optional
    track_id:integer,notnull
} -properties {
} -validate {
} -errors {
}


set items_list [list]
set control_list [list]

set org_id [db_string get_org_id { select org_id from ims_cp_organizations where man_id = :man_id} ]
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
    lappend control_list $ims_item_id
    incr count
}

template::multirow create tree_items link label indent last_indent target 

while { $count < $items_count } {
    foreach item $items_list {
	set item_id [lindex $item 0]
	set indent [expr [lindex $item 1] + 1]
	db_foreach get_items { select ims_item_id from ims_cp_items where parent_item = :item_id and org_id = :org_id } {
            if { [string equal [lsearch -exact $control_list $ims_item_id] "-1"] } {
		lappend items_list [list $ims_item_id $indent]
		lappend control_list $ims_item_id
		incr count
	    }
	}
    }
}

set community_id [dotlrn_community::get_community_id]
set counter 1
set user_id [ad_conn user_id]

proc generate_tree_menu { items index rlevel } {
    # This function is recursive

    set adp_level [template::adp_level]
    upvar TREE_HASH TREE_HASH
    upvar index localindex
    upvar #$adp_level counter counter
    upvar #$adp_level ims_id ims_id
    set itemcount [llength $items]

    # Loop through first level items
    # Sub-items are recursed
    while { $index < $itemcount } {
	set one [lindex $items $index]
	set level [lindex $one 0]
	set item_id [lindex $one 1]
	set title [lindex $one 2]
	
	set title [fs::remove_special_file_system_characters -string $title]
	regsub {'} $title {\'} title

	# as suggested by Michele Slocovich (michele@sii.it)
	# http://openacs.org/bugtracker/openacs/com/lors/bug?bug%5fnumber=2100
	#
	set title [string map { \{ \\{ \} \\} } $title ]

	upvar #$adp_level man_id man_id
	set url "[export_vars -base "record-view" \
			 -url {item_id man_id}]"
 
	if { $index < [expr $itemcount - 1] } {
	    # Get the tree level of the next item
	    set nextlevel [lindex [lindex $items [incr index]] 0]
	    
	    # Loop through each item until an item with a different
	    # level is encountered
	    if { $level == $nextlevel } {
		# Another item in the same level, just add to the list
		lappend TREE_HASH "TREE_HASH\[\"ims_id.$item_id\"\] = $counter;"
		lappend levelitems "\['$title', $url\]"
		template::multirow append tree_items $url $title $level
		incr counter
	    } elseif { $level < $nextlevel } {
		# Next item is a sub-item
		set ocounter $counter
		incr counter
		set submenu "[generate_tree_menu $items $index [expr $rlevel + 1]]"
		lappend TREE_HASH "TREE_HASH\[\"ims_id.$item_id\"\] = $ocounter;"
		template::multirow append tree_items $url $title $level
		if { [llength $submenu] } {
		    # There's a submenu
		    lappend levelitems \
			"\['$title',  $url,\n$submenu\n\]"
		} else {
		    # Child is a lone leaf node, if so, it should have
		    # replace the url, the item_id and decremented counter
		    lappend levelitems \
			"\['$title',  $url\]"
		}

		# The index should have been adjusted by now to point
		# to the next item, let's see if the next item has a
		# lower level, if so, it's time to return
		if { $index < $itemcount } {
		    set nextlevel [lindex [lindex $items $index] 0]
		    if { $level > $nextlevel } {
			set localindex $index
			return [join $levelitems ",\n"]
		    }
		}
		
	    } else {
		# Next item has lower level
		set localindex $index

		# If i'm alone in this level, there's really no point
		# for my existence, i'll just give my URL to my parent
		if { ![info exists levelitems] } {
		    upvar url my_url
		    upvar item_id my_item_id
		    set my_url $url
		    set my_item_id $item_id

		    return [list]
		} else {
		    lappend TREE_HASH "TREE_HASH\[\"ims_id.$item_id\"\] = $counter;"
		template::multirow append tree_items $url $title $level
		    incr counter
		    return [join \
				[lappend levelitems \
				     "\['$title', $url\]"
				] ",\n"
			   ]
		}
	    }
	} else {
	    # Terminator, end of the list
	    set localindex [expr $index + 1]
	    lappend TREE_HASH "TREE_HASH\[\"ims_id.$item_id\"\] = $counter;"
	    incr counter
	    return [join \
			[lappend levelitems \
			     "\['$title', $url\]"
			] ",\n"
		   ]
	}
    }

    set localindex $index
    return [join $levelitems ",\n"]
}

# Counter starts at 1 coz Course Index isn't part of the list

db_foreach organizations {
    select 
       org.org_id,
       org.org_title as org_title,
       org.hasmetadata,
       man_id,
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
 	--	(tree_level(ci.tree_sortkey) - :indent) as indent,
         	i.parent_item,
 		i.ims_item_id,
                i.item_title as item_title,
	        cr.mime_type
        FROM 
		acs_objects o, ims_cp_items i, cr_items ci, cr_revisions cr,
	        ims_cp_items_map im
	WHERE 
		o.object_type = 'ims_item_object'
           AND
		i.org_id = :org_id
	   AND
		o.object_id = i.ims_item_id
	   AND
		i.ims_item_id = im.ims_item_id
           and im.man_id=:man_id
	   and im.org_id=:org_id
	   and im.hide_p='f'
	   and im.community_id=:community_id
	   and ci.item_id=cr.item_id
           and cr.revision_id=i.ims_item_id

	   AND 
	   	EXISTS
		(select 1
		   from acs_object_party_privilege_map p
		  where p.object_id = i.ims_item_id 
		    and p.party_id = :user_id
		    and p.privilege = 'read')

        ORDER BY 
               i.sort_order, o.object_id, ci.tree_sortkey
    } {
        foreach item $items_list {
            set item_id [lindex $item 0]
            set indent [lindex $item 1]
            if { [string equal $item_id $ims_item_id] } {
		lappend js [list $indent $ims_item_id $item_title $man_id $mime_type]    
	    }
	}
    }
}

if { [info exists js] } {
    set last_indent 1
    foreach l $js {
	foreach {indent item_id title man_id mime_type} $l {break}
	template::multirow append tree_items [export_vars -base "record-view" \
			 -url {item_id man_id}] "$title  $mime_type" $indent $last_indent
	set last_indent $indent
    }
}
# return_url
set return_url [dotlrn_community::get_community_url [dotlrn_community::get_community_id]]
