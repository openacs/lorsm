# packages/lorsm/www/tracking/index.tcl

ad_page_contract {
    
    Student Tracking Index Page
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-05-25
    @arch-tag a5b230ee-0fa7-4e48-be1b-eeae323291e7
    @cvs-id $Id$
} {
    man_id:integer,notnull
    {item_id 0}
    group:optional
} -properties {
} -validate {
} -errors {
}

set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]

set admin_p [dotlrn::user_can_admin_community_p  \
		 -user_id [ad_conn user_id]  \
		 -community_id $community_id ]


set title "Student Tracking"
set context {Tracking}

if {![exists_and_not_null group]} {
    set group 1
}

if {$group == 1} {

    template::list::create \
	-name student_track \
	-multirow student_track \
	-actions [list "Summarize" [export_vars -base ".?group=0" {man_id item_id}] "Summarize all students"] \
	-key man_id \
	-html {width 50%} \
	-no_data "No Students" \
	-elements {
	    student_name {
		label "Student Name"
		display_eval {[person::name -person_id $student_name]}
		link_url_eval {[acs_community_member_url -user_id $student_name]}
		link_html {title "Student's profile"}
	    }
	    start_time {
		label "Start Course"
		display_eval {[lc_time_fmt $start_time "%x %T"]}
		html { align center }
	    }
	    end_time {
		label "Exit Course"
		display_eval {[lc_time_fmt $end_time "%x %T"]}
		html { align center }
	    }
	    time_spend {
		label "Time Spent"
		display_eval {[lorsm::dates_calc -start_date [lc_time_fmt $start_time "%x %T"] -end_date [lc_time_fmt $end_time "%x %T"]]}
		html { align center }
	    }
	}

    db_multirow -extend { ims_md_id } student_track select_students {
	select 
	user_id as student_name,
	start_time,
	end_time
	from
	lorsm_student_track
	where 
	community_id = :community_id
	and
	course_id    = :man_id
        and
           end_time NOTNULL
	order by  
	start_time desc
    } {
	set ims_md_id $man_id
    }
    
    template::list::create \
        -name object_views \
        -multirow object_views \
        -elements {
            title {
                label "Title"
            }
            viewer_name {
                label "Viewed By"
            }
            views {
                label "Total Views"
            }
            last_viewed {
                label "Last Viewed On"
            }
        }

    if {$item_id} {
	set extra_where " and v.object_id = :item_id"
    } else {
	set extra_where ""
    }

    db_multirow -extend {viewer_name} object_views objects_views "
        select v.*,
               i.title
        from views v,
             ims_cp_items i,
             ims_cp_organizations o
        where
             i.item_id = v.object_id
        and
             i.org_id = o.org_id
	and
             o.man_id = :man_id
        $extra_where
    " {
        set viewer_name [acs_user::get_element -user_id $viewer_id -element name]
    }

} else {
    # group display

    template::list::create \
	-name student_track \
	-multirow student_track \
	-key man_id \
	-actions [list "Expand" [export_vars -base ".?group=1" {man_id item_id}] "Expand all students"] \
	-html {width 50%} \
	-no_data "No Students" \
	-elements {
	    student_name {
		label "Student Name"
		display_eval {[person::name -person_id $student_name]}
		link_url_eval {[acs_community_member_url -user_id $student_name]}
		link_html {title "Student's profile"}
	    }
	    counter {
		label "Times Viewed"
		html { align center }
	    }
	    time_spent {
		label "Time Spent"
		html { align center }
	    }
	}

    db_multirow -extend { ims_md_id } student_track select_students {
	select 
	user_id as student_name,
	count(*) as counter,
	sum(end_time - start_time) as time_spent
	from
	lorsm_student_track
	where 
	community_id = :community_id
	and
	   course_id    = :man_id
	and 
	   end_time  NOTNULL
	group by user_id

    } {
	set ims_md_id $man_id
    }

    template::list::create \
        -name object_views \
        -multirow object_views \
        -elements {
            title {
                label "Title"
            }
            views {
                label "Total Views"
            }
            unique_views {
                label "Unique Views"
            }
            last_viewed {
                label "Last Viewed On"
            }
        }
    
    if {$item_id} {
	set extra_where " and v.object_id = :item_id"
    } else {
	set extra_where ""
    }

    db_multirow object_views objects_views "
        select v.*,
               i.title
        from view_aggregates v,
             ims_cp_items i,
             ims_cp_organizations o
        where
             i.item_id = v.object_id
        and
             i.org_id = o.org_id
	and
             o.man_id = :man_id
        $extra_where
    "

}
