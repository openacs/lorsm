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
set community_id [lors::get_community_id]

set title "[_ lorsm.lt_Set_Course_Track_Opti]"
set context [list "[_ lorsm.Set_Course_Options]"]

ad_form \
    -name tracker \
    -export {package_id} \
    -select_query_name tracker_ad_form \
    -form {
        {man_id:key}

        {project:text(inform)
            {label "[_ lorsm.Course_Name]"}
            {value {[lorsm::get_course_name -manifest_id $man_id]}}
        }

        {istrackable:text(inform)
            {label "[_ lorsm.Current_Status]"}
        }

        {enable:text(radio)
            {label Status?}
            {options {{"[_ lorsm.Trackable_1]" t} {"[_ lorsm.No_Thanks]" f}}}
        }

    } -edit_data {
        db_dml do_update {}

    } -after_submit {
        ad_returnredirect [site_node::get_url_from_object_id -object_id package_id]
        ad_script_abort
    }
