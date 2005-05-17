# packages/lorsm/www/delivery/index.tcl

ad_page_contract {
    
    Course Delivery Table of Content
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-09
    @arch-tag 553390f0-450e-48db-99f0-c5dcb17978b8
    @cvs-id $Id$
} {
    man_id:integer,notnull  
} -properties {
} -validate {
} -errors {
}


set package_id [ad_conn package_id]

# In order to share courses across classes, we need to share
# file-storage objects across file-storage instances. This has been
# proven to be really tricky. But here we pass the fs_package_id for
# the current community, so we don't have to have permissions for
# other instances of file-storages of other classes.  See
# documentation for further details.

set community_id [dotlrn_community::get_community_id]
set fs_local_package_id [site_node_apm_integration::get_child_package_id \
		       -package_id [dotlrn_community::get_package_id $community_id] \
		       -package_key "file-storage"\
		      ]


if {[db_0or1row manifest "
    select 
           cp.man_id,
           cp.course_name,
           cp.identifier,
           cp.version,
           text 'Yes' as hello,
           case
              when hasmetadata = 't' then 'Yes'
              else 'No'
           end as man_metadata,
           case 
              when isscorm = 't' then 'Yes'
              else 'No'
           end as isscorm,
           cp.fs_package_id,
           cp.folder_id,
	   acs.creation_user,
	   acs.creation_date,
	   acs.context_id
    from
           ims_cp_manifests cp, acs_objects acs
    where 
           cp.man_id = acs.object_id
	   and  cp.man_id = :man_id
           and  cp.parent_man_id = 0"]} {

    
    # Course Name
    if {[empty_string_p $course_name]} {
	set course_name "[_ lorsm.No_course_Name]"
    } 

    # Version
    if {[empty_string_p $version]} {
	set version "[_ lorsm.No_version_Available]"
    } 
    
    # Instance
    set instance [apm_package_key_from_id $fs_package_id]

    # Folder
    set folder [apm_package_url_from_id $fs_package_id]?[export_vars folder_id]

    # Student tracking
    set package_id [ad_conn package_id]
    set community_id [dotlrn_community::get_community_id]
    set user_id [ad_conn user_id]

    if {[lorsm::track::istrackable -course_id $man_id -package_id $package_id]} {

	set track_id [lorsm::track::new \
			  -user_id $user_id \
			  -community_id $community_id \
			  -course_id $man_id]
    } else {
	set track_id 0
    }

} else {

    set display 0
    
}



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
		i.ims_item_id as item_id,
                i.item_title as item_title
        FROM 
		acs_objects o, ims_cp_items i
	WHERE 
		o.object_type = 'ims_item_object'
           AND
		i.org_id = :org_id
	   AND
		o.object_id = i.ims_item_id
	   AND 
	   	EXISTS
		(select 1
		   from acs_object_party_privilege_map p
		  where p.object_id = i.ims_item_id 
		    and p.party_id = :user_id
		    and p.privilege = 'read')

        ORDER BY 
                o.object_id, tree_sortkey
    } {
	lappend js_file [list $indent $item_id $item_title]
    }
}


if {![exists_and_not_null js]} {

    set js [list]
    # the first element must be blank
    lappend js [list 0 0 "[_ lorsm.Course_Index]"]

}

foreach one $js_file {
    lappend js [list [lindex $one 0] [lindex $one 1] [lindex $one 2]]
#    ns_write "[lindex $one 0] [lindex $one 1] [lindex $one 2]\n"
}


set counter 0
set counterx 0
set maxcols 0
set jsfile  "var tocTab = new Array();\n"

foreach one $js {

    if {[lindex $one 0] != 0 } {

	for {set x [lindex [lindex $js [expr $counter -1]] 0]} {$x < [lindex $one 0]} {incr x} {
	    set counterx [concat $counterx.$x]
	} 
	
	for {set x [lindex [lindex $js [expr $counter -1]] 0]} {$x > [lindex $one 0]} {set x [expr $x -1]} {
	    
	    set counterx [string range $counterx 0 [expr [string length $counterx] - [expr 1 + [string length [file extension $counterx]]]]]
	    
	}
	
	
	if { [lindex [lindex $js [expr $counter -1]] 0] >= [lindex $one 0]} {
	    
	    set subnum [string range $counterx [expr  [string length $counterx] -1]  [string length $counterx]]
	    set subnum [expr $subnum + 1]
	    set counterx [string replace $counterx [expr  [string length $counterx] -1]  [string length $counterx] $subnum]
	    
	}
	
	
    } else {
	set counterx $counter
    }

    set item_id [lindex $one 1]    

    if {[lindex $one 1] == 0} {

	set url ""
	
    } else {

	set url [export_vars -base record-view {man_id item_id}]

    }

    set jsfile [concat $jsfile  "tocTab\[$counter\] = new Array (\"$counterx\", \"[lindex $one 2]\", \"$url\"); \n"]
    incr counter

    # maxcols

    if {[lindex $one 0] > $maxcols} {
	set maxcols [lindex $one 0]
    }
    
}

set jsfile [concat $jsfile "var nCols = [expr $maxcols + 1];"]


#ns_write $jsfile