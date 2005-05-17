# packages/lorsm/www/test.tcl

ad_page_contract {
    
    testing background
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-06-15
    @arch-tag: 9d893919-9a02-45cd-b6ad-19e3a34ba747
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}

template::list::create \
    -name d_courses \
    -multirow d_courses \
    -html {width 100%} \
    -key man_id \
    -no_data "[_ lorsm.No_Courses]" \
    -elements {
        course_name {
            label "[_ lorsm.Course_Name_1]"
	    display_template {@d_courses.course_url;noquote@}
	    html { width 70% }
        }
        subject {
            label "[_ lorsm.Subject]"
            display_eval {[dotlrn_community::get_community_name $community_id]}
	    html { align center width 20% }
            link_url_eval {[dotlrn_community::get_community_url $community_id]}
            link_html {title "[_ lorsm.Access_Course]"}
        }
        last_viewed {
            label "[_ lorsm.Last_Viewed_On]"
            html { align center width 10% }
            display_eval {[lc_time_fmt $last_viewed "%x"]}
        }
        viewed_percent {
            label "[_ lorsm._Viewed]"
            html { align right }
            display_eval {[lc_numeric $viewed_percent "%.2f"]}
        }
    }

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set extra_query ""
if {![empty_string_p $community_id]} {
    set extra_query "and cpmc.community_id = :community_id"
}
foreach package $package_id {
    db_multirow -extend { ims_md_id last_viewed total_item_count viewed_item_count viewed_percent course_url } -append d_courses select_d_courses { } {
        set ims_md_id $man_id
	if { [string eq $format_name "default"] } {
			set course_url "<a href=\"[site_node::get_url_from_object_id -object_id $lorsm_instance_id]${folder_name}/?[export_vars man_id]\" title=\"[_ lorsm.Access_Course]\">$course_name</a>" 
	} else {
			set course_url "<a href=\"[site_node::get_url_from_object_id -object_id $lorsm_instance_id]${folder_name}/?[export_vars man_id]\" title=\"[_ lorsm.Access_Course]\" target=_blank>$course_name</a>" 
	}
        # DEDS: these are expensive
        # and for demo purposes only
        db_0or1row get_last_viewed { }
        set all_items [db_list get_total_items { }]
        set total_item_count [llength $all_items]
        set viewed_items [db_list get_viewed_items { }]
        set viewed_item_count [llength $viewed_items]
        set viewed_percent [expr [expr $viewed_item_count * 1.00] / $total_item_count * 100]
    }
}


