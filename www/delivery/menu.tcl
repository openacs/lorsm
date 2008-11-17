# packages/lorsm/www/delivery/menu.tcl

ad_page_contract {

    Course Delivery Table of Content

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-09
    @arch-tag 553390f0-450e-48db-99f0-c5dcb17978b8
    @cvs-id $Id$
} {
    man_id:integer,notnull
    ims_id:integer,notnull,optional
    menu_off:integer,notnull,optional
    track_id:integer,notnull,optional
} -properties {
} -validate {
} -errors {
}

if { ![info exists track_id] } {
        set track_id 0 }

if { ![info exists menu_off] } {
        set menu_off 0 }

set debuglevel [ad_get_client_property lorsm debuglevel]
set deliverymethod [ad_get_client_property lorsm deliverymethod]

if { [string equal $deliverymethod "delivery-scorm"] } {
    set rte true
} else {
    set rte false
}

set items_list [list]

foreach org_id [db_list get_org_id { } ] {
    foreach item [lorsm::get_items_indent -org_id $org_id] {lappend items_list $item}
}
template::util::list_of_lists_to_array $items_list items_array
set fs_package_id [db_string get_fs_package_id { } -default "" ]

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

        set url "'[export_vars \
                    -base "record-view" \
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
                    lappend TREE_HASH \
                            "TREE_HASH\[\"ims_id.$item_id\"\] = $counter;"
                    incr counter
                    return [join [lappend levelitems "\['$title', $url\]"] ",\n"]
                }
            }
        } else {
            # Terminator, end of the list
            set localindex [expr $index + 1]
            lappend TREE_HASH "TREE_HASH\[\"ims_id.$item_id\"\] = $counter;"
            incr counter
            return [join [lappend levelitems "\['$title', $url\]"] ",\n"]
        }
    }
    set localindex $index
    return [join $levelitems ",\n"]
}

# Counter starts at 1 coz Course Index isn't part of the list

db_foreach organizations { } {
    ns_log notice "menu.tcl org_id=$org_id"
    # If the course is from lors-central we need an extra query

    if {[apm_package_installed_p lors-central] && [empty_string_p $fs_package_id] } {
        set extra_query "
            and i.ims_item_id in
                ( select im.ims_item_id
                from ims_cp_items_map im
                where man_id = $man_id
                    and org_id = $org_id
                    and community_id = $community_id
                    and hide_p = 'f'
                )"
    } else {
        set extra_query ""
    }

    db_foreach sql {
        select i.parent_item, i.ims_item_id, i.item_title as item_title
        from ims_cp_items i, cr_items ci, cr_revisions cr
        where i.org_id = :org_id
            and ci.item_id=cr.item_id
            and cr.revision_id=i.ims_item_id
            and exists (select 1
                        from acs_object_party_privilege_map p
                        where p.object_id = i.ims_item_id
                            and p.party_id = :user_id
                            and p.privilege = 'read')
        order by i.sort_order,ci.tree_sortkey
    } {
        set indent $items_array($ims_item_id)
        ns_log notice "ims_item_id='${ims_item_id}'"
        lappend js [list $indent $ims_item_id $item_title]
    }
}

if { [info exists js] } {
    set index 0
    set TREE_ITEMS [generate_tree_menu $js $index 1]
    set TREE_HASH [join $TREE_HASH "\n"]
}
# return_url
set return_url [dotlrn_community::get_community_url \
                    [dotlrn_community::get_community_id]]
