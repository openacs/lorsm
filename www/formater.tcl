# packages/lorsm/www/formater.tcl

ad_page_contract {
    
    Change course format presentation
    
    @author jopezku@gmail.com
    @cvs-id $Id$
} {
    man_id:integer
    return_url
} -properties {
} -validate {
} -errors {
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]

# check admin permisssion for the community
set admin_p [dotlrn::user_can_admin_community_p  \
				 -user_id $user_id  \
		 -community_id $community_id ]

# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

# check write permisssion for the learning object/manifest
permission::require_write_permission -object_id $man_id -creation_user $user_id


set title "[_ lorsm.lt_Set_Course_Presentati]"
set context [list "[_ lorsm.lt_Set_Course_Presentati]"]

ad_form -name formater \
    -export {return_url} \
    -form {
		{man_id:key}
		{project:text(inform)
			{label "[_ lorsm.Course_Name]"}
			{value {[lorsm::get_course_name -manifest_id $man_id]}}
		}
		{format_pretty_name:text(inform)
			{label "[_ lorsm.Current_Format]"}
		}
		{format:text(select)
			{label "[_ lorsm.Format_1]"}
			{options {[db_list_of_lists select_formats_for_select_widget {select format_pretty_name,
				format_id
				from lorsm_course_presentation_formats
				order by format_pretty_name}]}}
		}
	} -select_query {
		select cp.course_presentation_format as format, pf.format_pretty_name
		from ims_cp_manifests cp, lorsm_course_presentation_formats pf
		where cp.man_id = :man_id
		and cp.course_presentation_format = pf.format_id
	} -edit_data {
		db_transaction {
			db_dml do_update {
				update ims_cp_manifests
				set course_presentation_format = :format
				where man_id = :man_id }
		}	
	} -after_submit {
		ad_returnredirect $return_url
	}




