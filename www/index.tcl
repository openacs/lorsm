ad_page_contract {
    Learning Object Repository Management Index page

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 19 January 2003
    @cvs-id $Id$

} {
}

set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]

set admin_p [dotlrn::user_can_admin_community_p  \
		 -user_id [ad_conn user_id]  \
		 -community_id $community_id ]


template::list::create \
    -name d_courses \
    -multirow d_courses \
    -html {width 50%} \
    -key man_id \
    -no_data "No Courses" \
    -elements {
        course_name {
            label "Course Name"
            display_col course_name
            link_url_eval {delivery/?[export_vars man_id]}
            link_html {title "Access Course"}

        }
        course_structure {
            label "Course Structure"
	    display_eval {\[view\]}
            link_url_eval {course-structure?[export_vars man_id]}
            link_html {title "Course Structure"}
	    html { align center }
        }
        hasmetadata {
            label "Metadata?"
            link_url_eval {md/?[export_vars ims_md_id]}
            link_html {title "See metadata"}
	    html { align center }
        }
        isscorm {
            label "SCORM?"
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
        export {
            label "Export"
	    display_eval {\[zip\]}
            link_url_eval {export/?[export_vars folder_id]}
            link_html {title "Export as IMS Content Package"}
	    html { align center }
        }
    }

db_multirow -extend { ims_md_id } d_courses select_d_courses {
    select 
           cp.man_id,
           cp.course_name,
           cp.identifier,
           cp.version,
           case
              when hasmetadata = 't' then 'Yes'
              else 'No'
           end as hasmetadata,
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
    and
           acs.context_id = :package_id
} {
    set ims_md_id $man_id
}
 
