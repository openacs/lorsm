# packages/lorsm/www/delivery/index.tcl

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

	upvar #$adp_level man_id man_id
	set url "'[export_vars -base "record-view" \
			 -url {item_id man_id}]'"
 
	if { $index < [expr $itemcount - 1] } {
	    # Get the tree level of the next item
	    set nextlevel [lindex [lindex $items [incr index]] 0]
	    
	    # Loop through each item until an item with a different
	    # level is encountered
	    if { $level == $nextlevel } {
		# Another item in the same level, just add to the list
		lappend TREE_HASH "TREE_HASH\[\"ims_id.$item_id\"\] = $counter;"
		lappend levelitems "\['$title', $url\]"
		incr counter
	    } elseif { $level < $nextlevel } {
		# Next item is a sub-item
		set ocounter $counter
		incr counter
		set submenu "[generate_tree_menu $items $index [expr $rlevel + 1]]"
		lappend TREE_HASH "TREE_HASH\[\"ims_id.$item_id\"\] = $ocounter;"

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
       org.title as org_title,
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

    set indent [expr $indent +1]

    db_foreach sql {		   
        SELECT
 		(tree_level(tree_sortkey) - :indent) as indent,
		i.item_id,
                i.title as item_title
        FROM 
		acs_objects o, ims_cp_items i
	WHERE 
		o.object_type = 'ims_item'
           AND
		i.org_id = :org_id
	   AND
		o.object_id = i.item_id
	   AND 
	   	EXISTS
		(select 1
		   from acs_object_party_privilege_map p
		  where p.object_id = i.item_id 
		    and p.party_id = :user_id
		    and p.privilege = 'read')

        ORDER BY 
                o.object_id, tree_sortkey
    } {
	lappend js [list $indent $item_id $item_title]
    }
}
    
if { [info exists js] } {
    set index 0
    set TREE_ITEMS [generate_tree_menu $js $index 1]
    set TREE_HASH [join $TREE_HASH "\n"]
}

# return_url
set return_url [dotlrn_community::get_community_url [dotlrn_community::get_community_id]]
