# packages/lorsm/www/sharer.tcl

ad_page_contract {

    Enable sharing of courses, organizations and learning objects

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-07-09
    @arch-tag: 0d48cf78-3d5d-4a39-b2e0-2f090bfbecb8
    @cvs-id $Id$
} {
    man_id:integer
    folder_id:integer
    return_url
} -properties {
} -validate {
} -errors {
}

set user_id [ad_conn user_id]

set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]

# check write permisssion for the learning object/manifest
permission::require_write_permission -object_id $man_id -creation_user $user_id


set title "[_ lorsm.lt_Share_CourseLearning_]"
set context [list "[_ lorsm.lt_Share_CourseLearning_]"]

ad_form \
    -name sharer \
    -export {return_url folder_id} \
    -form {
        {man_id:key}

        {project:text(inform)
            {label "[_ lorsm.Course_Name]"}
            {value {[lorsm::get_course_name -manifest_id $man_id]}}
        }

        {isshared:text(inform)
            {label "[_ lorsm.Current_Status]"}
        }

        {share:text(radio)
            {label Status?}
            {options {{"[_ lorsm.Shared]" t} {"[_ lorsm.Not_Shared]" f}}}
        }

    } -select_query_name sharer_ad_form {

    } -edit_data {
        db_transaction {
            db_dml do_update {}

            if {$share == "t"} {

                set party_id_students [db_string party_id {}]

                permission::grant \
                    -party_id $party_id_students \
                    -object_id $man_id \
                    -privilege read

                permission::grant \
                    -party_id $party_id_students \
                    -object_id $folder_id \
                    -privilege read

            } else {

                set party_id_students [db_string party_id {}]

                permission::revoke \
                    -party_id $party_id_students \
                    -object_id $man_id \
                    -privilege read

                permission::revoke \
                    -party_id $party_id_students \
                    -object_id $folder_id \
                    -privilege read

            }
        }
    } -after_submit {
        ad_returnredirect $return_url

    }
