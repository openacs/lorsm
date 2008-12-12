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
            {options {[lang::util::localize_list_of_lists \
                -list [db_list_of_lists select_formats_for_select_widget {}]]}}
        }

    } -edit_request {
        db_1row get_data {}
        set format_pretty_name [lang::util::localize $format_pretty_name]

    } -edit_data {
        db_transaction {
            db_dml do_update {}
        }

    } -after_submit {
        ad_returnredirect $return_url
    }




