# packages/lorsm/www/enabler.tcl

ad_page_contract {
    
    enable/disable courses for a class
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-05-19
    @arch-tag ebea2a9b-b6d6-4083-83c5-58686ba9e201
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



set title "Set Course Trackable"
set context [list "Set Course Status"]

ad_form -name enabler \
    -export {package_id} \
    -form {
	{man_id:key}
	{project:text(inform)
	    {label "Course Name:"}
	    {value {[lorsm::get_course_name -manifest_id $man_id]}}
	}
	{isenabled:text(inform)
	    {label "Current Status:"}
	}
	{enable:text(radio)
	    {label Status?}
	    {options {{"Enable" t} {"Disable" f}}}
	}
    } -select_query {
        select 
        case when isenabled = 't' then 'Enabled'
          else 'Disabled'
        end as isenabled
	from ims_cp_manifest_class
	where man_id = :man_id and 
	lorsm_instance_id = :package_id
    } -edit_data {
        db_dml do_update "
            update ims_cp_manifest_class
            set isenabled = :enable
            where man_id = :man_id and 
            lorsm_instance_id = :package_id"
    } -after_submit {
        ad_returnredirect [site_node::get_url_from_object_id -object_id package_id]
        ad_script_abort
    }





