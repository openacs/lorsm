# packages/lorsm/lib/user-lorsm.tcl
#
# User portlet view
#
# @author Ernie Ghiglione (ErnieG@mm.st)
# @creation-date 2004-04-10
# @arch-tag c4c3448b-3f12-43cc-9f96-19b4c4a72a58
# @cvs-id $Id$

foreach required_param {package_id} {
    if {![info exists $required_param]} {
	return -code error "$required_param is a required parameter."
    }
}

template::list::create \
    -name d_courses \
    -multirow d_courses \
    -html {width 100%} \
    -key man_id \
    -no_data "No Courses" \
    -elements {
        course_name {
            label "Course Name"
            display_col course_name
            link_url_eval {[site_node::get_url_from_object_id -object_id $context_id]delivery/?[export_vars man_id]}
            link_html {title "Access Course"}
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
    }

db_multirow -extend { ims_md_id } d_courses select_d_courses {
    select 
           cp.man_id,
           cp.course_name,
           cp.identifier,
           cp.version,
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

