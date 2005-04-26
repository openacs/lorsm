#packages/lorsm/www/test.tcl

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

#set package_id $list_of_packages_ids

#            link_url_eval {[site_node::get_url_from_object_id -object_id $lorsm_instance_id]${folder_name}/?[export_vars man_id]}
#            link_html {title "[_ lorsm.Access_Course]" target "_blank"}

	
template::list::create \
    -name d_courses \
    -pass_properties delivery_folder \
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

foreach package $package_id {

    db_multirow -extend { ims_md_id last_viewed total_item_count viewed_item_count viewed_percent course_url } -append  d_courses select_d_courses {
	select 
	   cp.man_id,
           cp.course_name,
           cp.identifier,
           cp.version,
           cp.fs_package_id,
           cp.folder_id,
	   acs.creation_user,
	   acs.creation_date,
	   pf.folder_name,
	   pf.format_name,
	   acs.context_id,
           cpmc.community_id,
           cpmc.lorsm_instance_id
	from
           ims_cp_manifests cp, acs_objects acs, ims_cp_manifest_class cpmc, lorsm_course_presentation_formats pf
	where 
           cp.man_id = acs.object_id
	and
           cp.man_id = cpmc.man_id
	and
--	   acs.context_id = :package
           cpmc.lorsm_instance_id = :package
	and
           cpmc.isenabled = 't'
	and
		   cp.course_presentation_format = pf.format_id
	order by acs.creation_date desc
    } {
        set ims_md_id $man_id
		if { [string eq $format_name "default"] } {
			set course_url "<a href=\"[site_node::get_url_from_object_id -object_id $lorsm_instance_id]${folder_name}/?[export_vars man_id]\" title=\"[_ lorsm.Access_Course]\">$course_name</a>" 
		} else {
			set course_url "<a href=\"[site_node::get_url_from_object_id -object_id $lorsm_instance_id]${folder_name}/?[export_vars man_id]\" title=\"[_ lorsm.Access_Course]\" target=_blank>$course_name</a>" 
		}
		
        # DEDS: these are expensive
        # and for demo purposes only
        db_0or1row get_last_viewed {
            select v.last_viewed
              from views v,
                   ims_cp_items i,
                   ims_cp_organizations o
             where v.viewer_id = :user_id
               and v.object_id = i.item_id
               and i.org_id = o.org_id
               and o.man_id = :man_id
            order by v.last_viewed desc
            limit 1
        }
        set all_items [db_list get_total_items {
            select i.item_id
              from ims_cp_items i,
                   ims_cp_organizations o
             where o.man_id = :man_id
               and i.org_id = o.org_id   
        }]
        set total_item_count [llength $all_items]
        set viewed_items [db_list get_viewed_items "
            select v.object_id
              from views v
             where v.viewer_id = :user_id
               and v.object_id in ([join $all_items ,])
        "]
        set viewed_item_count [llength $viewed_items]
        set viewed_percent [expr [expr $viewed_item_count * 1.00] / $total_item_count * 100]
    
	}
}
