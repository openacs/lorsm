# packages/lorsm/www/tracker.tcl

ad_page_contract {
    
    set a course for a class to be trackable
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-05-25
    @arch-tag 07ceb832-2053-4579-bec2-76708522707a
    @cvs-id $Id$
} {
    man_id:integer,notnull
} -properties {
} -validate {
} -errors {
}

set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]

set admin_p [dotlrn::user_can_admin_community_p  \
		 -user_id [ad_conn user_id]  \
		 -community_id $community_id ]

# Permissions
dotlrn::require_user_admin_community -user_id [ad_conn user_id] -community_id $community_id


# Checks whether the user has appropiate permissions otherwise we kick
# him out
if {!$admin_p} {
        ad_returnredirect "not-allowed"
        return -code error
}


set title "Set Course Track Options"
set context [list "Set Course Options"]

ad_form -name tracker \
    -export {package_id} \
    -form {
	{man_id:key}
	{project:text(inform)
	    {label "Course Name:"}
	    {value {[lorsm::get_course_name -manifest_id $man_id]}}
	}
	{istrackable:text(inform)
	    {label "Current Status:"}
	}
	{enable:text(radio)
	    {label Status?}
	    {options {{"Trackable?" t} {"No, Thanks" f}}}
	}
    } -select_query {
        select 
        case when istrackable = 't' then 'Yes'
          else 'No'
        end as istrackable
	from ims_cp_manifest_class
	where man_id = :man_id and 
	lorsm_instance_id = :package_id
    } -edit_data {
        db_dml do_update "
            update ims_cp_manifest_class
            set istrackable = :enable
            where man_id = :man_id and 
            lorsm_instance_id = :package_id"
    } -after_submit {
        ad_returnredirect [site_node::get_url_from_object_id -object_id package_id]
        ad_script_abort
    }





