# packages/lorsm/www/lib/repository-shared-courses.tcl

ad_page_contract {
    
     List all the shared courses in the repository
     View shared courses
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-07-09
    @arch-tag: 9dd389d3-195f-49ed-b610-ee893cde06d6
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}


set title "Shared Courses"
set context [list "Shared Courses"]

set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]

set admin_p [dotlrn::user_can_admin_community_p  \
		 -user_id [ad_conn user_id]  \
		 -community_id $community_id ]

set com_url [dotlrn_community::get_community_url $community_id]

template::list::create \
    -name d_courses \
    -multirow d_courses \
    -html {width 50%} \
    -key man_id \
    -no_data "No Courses" \
    -elements {
        course_name {
            label "Available Courses"
            display_col course_name
            link_url_eval {[export_vars -base $community_url/lorsm/shared/course-info {man_id fs_package_id folder_id}]}
            link_html {title "Access Course"}

        }
        hasmetadata {
            label "Metadata?"
            link_url_eval {[export_vars -base $community_url/lorsm/md {ims_md_id}]}
            link_html {title "See metadata" }
	    html { align center }
        }
        creation_user {
            label "Owner"
            display_eval {[person::name -person_id $creation_user]}
            link_url_eval {[acs_community_member_url -user_id $creation_user]}
        }
        creation_date {
            label "Creation Date"
            display_eval {[lc_time_fmt $creation_date "%x %X"]}
        }
        admin {
            label "Course Info"
	    display_eval {Info/View}
            link_url_eval {[export_vars -base $community_url/lorsm/shared/course-info man_id]}
            link_html {title "Info" class button}
	    html { align center }
        }
    }


db_multirow -extend { ims_md_id community_url } d_courses select_d_courses {
    select 
           cp.man_id,
           cp.course_name,
           cp.identifier,
           cp.version,
           case
              when hasmetadata = 't' then 'Yes'
              else 'No'
           end as hasmetadata,
           cp.fs_package_id,
           cp.folder_id,
	   acs.creation_user,
	   acs.creation_date,
	   acs.context_id
    from
           ims_cp_manifests cp, acs_objects acs
    where 
           cp.man_id = acs.object_id
    and
           cp.isshared = 't'
    order by acs.creation_date desc
} {
    set ims_md_id $man_id
    set community_url $com_url
}
 
