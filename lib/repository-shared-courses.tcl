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


set title "[_ lorsm.Shared_Courses]"
set context [list "[_ lorsm.Shared_Courses]"]

set package_id [ad_conn package_id]
set community_id [lors::get_community_id]
set com_url [lors::get_community_url]

template::list::create \
    -name d_courses \
    -multirow d_courses \
    -html {width 50%} \
    -key man_id \
    -no_data "[_ lorsm.No_Courses]" \
    -elements {
        course_name {
            label "[_ lorsm.Available_Courses]"
            display_col course_name
            link_url_eval {[export_vars \
                                -base $community_url/lorsm/admin/shared/course-info \
                                {man_id fs_package_id folder_id}]}
            link_html {title "[_ lorsm.Access_Course]"}

        } hasmetadata {
            label "[_ lorsm.Metadata_1]"
            link_url_eval {[export_vars -base $community_url/lorsm/md {ims_md_id}]}
            link_html {title "[_ lorsm.See_metadata]" }
            html { align center }

        } creation_user {
            label "[_ lorsm.Owner]"
            display_eval {[person::name -person_id $creation_user]}
            link_url_eval {[acs_community_member_url -user_id $creation_user]}
        } creation_date {
            label "[_ lorsm.Creation_Date]"
            display_eval {[lc_time_fmt $creation_date "%x %X"]}

        } add {
            label ""
            display_eval {[_ lorsm.Add_Course]}
            link_url_eval {[export_vars \
                            -base $community_url/lorsm/admin/add-shared-course {man_id}]}
            link_html {title "[_ lorsm.lt_Add_course_to_my_clas]" class button}

        } admin {
            label "[_ lorsm.Course_Info]"
            display_eval {Info/View}
            link_url_eval {[export_vars -base $community_url/lorsm/admin/shared/course-info man_id]}
            link_html {title "[_ lorsm.Info]" class button}
            html { align center }
        }
    }

db_multirow -extend { ims_md_id community_url } d_courses select_d_courses { } {
    set ims_md_id $man_id
    set community_url $com_url
}

