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
    menu_off:integer,notnull,optional
    track_id:integer,notnull,optional
} -properties {
} -validate {
} -errors {
}

if { ![info exists track_id] } {
    set track_id 0
}

if { ![info exists menu_off] } {
    set menu_off 0
}

set debuglevel [ad_get_client_property lorsm debuglevel]
set deliverymethod [ad_get_client_property lorsm deliverymethod]

if { [string equal $deliverymethod "delivery-scorm"] } {
    set rte true
} else {
    set rte false
}


set items_list [list]
set control_list [list]
set target "content"

#set org_id [db_string get_org_id {} ]


#we handle multiple orgs
foreach org_id [db_list get_org_id { } ] {
    set count 0
    lappend items_list [list $org_id 0]
    foreach item [lorsm::get_items_indent -org_id $org_id]  {
        #we shift everything to the right to get the orgs inserted there
        set indent [expr [lindex $item 1] +1 ]
        set item_id [lindex $item 0]
        set item [list $item_id $indent]
        lappend items_list $item
    }
    # We need all the count of all items (just live revisions)
    set items_count [db_string get_items_count {}]
    # Get the root items
    db_foreach get_root_item {} {
        #lappend items_list [list $ims_item_id 1]
        #lappend control_list $ims_item_id
        incr count
    }

    while { $count < $items_count } {
        foreach item $items_list {
            set item_id [lindex $item 0]
            set indent [expr [lindex $item 1] + 1]
            db_foreach get_items {} {
                if { [string equal [lsearch -exact $control_list $ims_item_id] "-1"] } {
                    #this duplicates ITEMS lappend items_list [list $ims_item_id $indent]
                    #lappend control_list $ims_item_id
                    incr count
                }
            }
        }
    }
}

template::multirow create tree_items icon link label indent last_indent target

set community_id [lors::get_community_id]
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

	set file_upload_name [ad_sanitize_filename -tolower $title]

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
                template::multirow append tree_items "SAMELEVEL" $url $title $level
                incr counter
            } elseif { $level < $nextlevel } {
                # Next item is a sub-item
                set ocounter $counter
                incr counter
                set submenu "[generate_tree_menu $items $index [expr $rlevel + 1]]"
                lappend TREE_HASH "TREE_HASH\[\"ims_id.$item_id\"\] = $ocounter;"
                template::multirow append tree_items "NEXTLEVEL" $url $title $level
                if { [llength $submenu] } {
                    # There's a submenu
                    lappend levelitems "\['$title',  $url,\n$submenu\n\]"
                } else {
                    # Child is a lone leaf node, if so, it should have
                    # replace the url, the item_id and decremented counter
                    lappend levelitems "\['$title',  $url\]"
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
                    template::multirow append tree_items "LEAF" $url $title $level
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

db_foreach organizations {} {
    #trying to visualize organizations
    lappend js [list 0 $org_id $org_title $man_id "ims/organization" ""]

    db_foreach sql {} {
        foreach item $items_list {
            set item_id [lindex $item 0]
            set indent [lindex $item 1]
            if { [string equal $item_id $ims_item_id] } {
                lappend js [list    $indent $ims_item_id \
                                    $item_title $man_id \
                                    $mime_type $prerequisites]
            }
        }
    }
}

if { [info exists js] } {
    set last_indent 1
    foreach l $js {
        foreach {indent item_id title man_id mime_type prerequisites} $l {
            break
        }

        #analyzing LESSON STATUS for the ITEM
        #this could as well become a lorsm:scorm:function

        ns_log debug "MENU-MK tree :  $indent $item_id $title "
        if { ! [string equal $mime_type "ims/organization"] } {
            if {  [ db_0or1row isnotanemptyitem {} ] } {
                set icon ""
            } else {
                #since the item has no elements it's a placeholder, we assume it's a folder.
                #time will tell if the assumption is correct.
                set icon "<img src=\"/resources/lorsm/icons/folder.gif\" alt=\"Folder\">"
            }

            if { ! [ db_0or1row isanysuspendedsession {} ]  } {
                #item has no track for the user
                #the icon should be the same as per "not yet visited"
                append icon "<img src=\"/resources/lorsm/icons/flag_white.gif\"
                                alt=\"Not attempted\">"
            } else {
                switch -regexp $lesson_status {
                    null {
                        append icon "<img src=\"/resources/lorsm/icons/flag_white.gif\"
                                        alt=\"Not attempted\">"

                    } incomplete {
                        append icon "<img src=\"/resources/lorsm/icons/flag_orange.gif\"
                                        alt=\"Incomplete\">"

                    } complete {
                        append icon "<img src=\"/resources/lorsm/icons/flag_green.gif\"
                                        alt=\"Completed\">"

                    } failed {
                        append icon "<img src=\"/resources/lorsm/icons/flag_red.gif\"
                                        alt=\"Failed\">"

                    } "not attempted" {
                        append icon "<img src=\"/resources/lorsm/icons/flag_white.gif\"
                                        alt=\"Not attempted\">"

                    } passed {
                        append icon "<img src=\"/resources/lorsm/icons/icon_accept.gif\"
                                        alt=\"Passed\">"

                    } default {
                        append icon "<span style=\"color:#ffffff\"> $lesson_status **</span> \
                                    <img src=\"/resources/lorsm/icons/flag_blue.gif\"
                                        alt=\"$lesson_status\">"}
                }
            }


            #we analize now prerequisites.

            #regsub -all {&} $prerequisites " " prerequisites
            regsub -all {[\{\}]} $prerequisites "" prerequisites
            regsub -all { & } $prerequisites " " prerequisites
            set prerequisites_list [split $prerequisites]

            foreach prer $prerequisites_list {
                if { ! [empty_string_p $prer]  } {
                    ns_log debug "MENU prerequisites for $item_id are $prer "
                    #in the following query we disregard the organization
                    if { ! [ db_0or1row givemeid {} ] } {
                        ns_log warning "MENU-MK: prerequisites not found comm: \
                                        $community_id, man: $man_id, org: \
                                        $org_id, item: $item_id"
                        continue
                    } else {
                        ns_log debug "THE REQUIRED ITEM IS $id_from_ref ";
                    }
                }

                if { ! [empty_string_p $id_from_ref]  } {
                    ns_log debug "MENU prerequisites for $item_id are $id_from_ref"
                    if { ! [ db_0or1row isanysuspendedsession2 {} ] } {
                        ns_log debug "NOT FOUND TRACK"
                        append icon "<img src=\"/resources/lorsm/icons/page_lock.gif\" alt=\"Missing prerequisite: Not attempted\">"
                    } else {
                        ns_log debug "ITEM ID $id_from_ref HAS A TRACK WITH $lex_status"
                        switch -regexp $lex_status {
                            null {
                                append icon "<img
                                    src=\"/resources/lorsm/icons/page_lock.gif\"
                                    alt=\"Missing prerequisite: Not attempted\">"

                            } incomplete {
                                append icon "<img
                                    src=\"/resources/lorsm/icons/page_lock.gif\"
                                    alt=\"Missing prerequisite: Incomplete\">"

                            } failed {
                                append icon "<img
                                    src=\"/resources/lorsm/icons/page_lock.gif\"
                                    alt=\"Missing prerequisite: Failed\">"

                            } "not attempted" {
                                append icon "<img
                                    src=\"/resources/lorsm/icons/page_lock.gif\"
                                    alt=\"Missing prerequisite: Not attempted\">"

                            } passed {
                                append icon "<img
                                    src=\"/resources/lorsm/icons/page_tick.gif\"
                                    alt=\"Prerequisite fulfilled\">"

                            } complete {
                                append icon "<img
                                    src=\"/resources/lorsm/icons/page_tick.gif\"
                                    alt=\"Prerequisite fulfilled\">"

                            } default {
                                append icon "<span style=\"color:#ffffff\">
                                                $lesson_status **
                                            </span>
                                            <img src=\"/resources/lorsm/icons/flag_blue.gif\"
                                            alt=\"$lesson_status\">"
                            }
                        }
                    }
                    #if found session for id_from_ref
                }
                #if found id_from_ref
            }
            #foreach close

            template::multirow append tree_items $icon [export_vars \
                                                        -base "record-view" \
                                                        -url {item_id man_id}] \
                                                        "$title $mime_type" $indent \
                                                        $last_indent $target
            set last_indent $indent

        } else {

            regsub -all {[\{\}]} $title "" title
            set icon "<img src=\"/resources/lorsm/icons/folder_page.gif\"
                        alt=\"Content Folder\">"

            if { ! [ db_0or1row isanysuspendedsession3 {} ] } {
                ns_log debug "Menu-mk: no org tracking found"
                append icon "<img
                                src=\"/resources/lorsm/icons/flag_white.gif\"
                                alt=\"Not attempted\">"
            } else {
                switch -regexp $lesson_status {
                    null {
                        append icon "<img
                                        src=\"/resources/lorsm/icons/flag_white.gif\"
                                        alt=\"Not attempted\">"

                    } incomplete {
                        append icon "<img
                                        src=\"/resources/lorsm/icons/flag_orange.gif\"
                                        alt=\"Incomplete\">"

                    } complete {
                        append icon "<img
                                        src=\"/resources/lorsm/icons/flag_green.gif\"
                                        alt=\"Completed\">"

                    } failed {
                        append icon "<img
                                        src=\"/resources/lorsm/icons/flag_red.gif\"
                                        alt=\"Failed\">"

                    } "not attempted" {
                        append icon "<img
                                        src=\"/resources/lorsm/icons/flag_white.gif\"
                                        alt=\"Not attempted\">"

                    } passed {
                        append icon "<img
                                        src=\"/resources/lorsm/icons/icon_accept.gif\"
                                        alt=\"Passed\">"

                    } default {
                        append icon "<span style=\"color:#ffffff\"> $lesson_status **</span>
                                        <img
                                            src=\"/resources/lorsm/icons/flag_blue.gif\"
                                            alt=\"$lesson_status\">"
                    }
                }
            }

            set last_indent $indent
            template::multirow append tree_items $icon "" \
                $title $indent $last_indent ""

            set last_indent $indent
        }
    }
}
# return_url
set return_url [ad_get_client_property lorsm return_url]

