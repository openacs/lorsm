# packages/lorsm/www/shared/add-shared-course.tcl

ad_page_contract {

    Adds an existing shared course to a .LRN class

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-07-12
    @arch-tag: 9f1edd88-ff55-4328-8f3b-6d014351e48a
    @cvs-id $Id$
} {
   man_id:integer
} -properties {
} -validate {
} -errors {
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set community_id [lors::get_community_id]

# check if the course is actually shared
if {[db_string isshared {}] == "f"} {
    # if it ain't complain and quit
    ad_complain "[_ lorsm.lt_The_course_you_are_tr]"
}

# check if the course is already added as course for this class

if {![db_0or1row exists {}]} {
    ad_complain "The course [lorsm::get_course_name -manifest_id $man_id], is already part of your class"
}

set title "[_ lorsm.lt_Add_Course_Confirmati]"
set course_name [lorsm::get_course_name -manifest_id $man_id]

set context [list \
                [list [export_vars -base .] "[_ lorsm.Shared_Courses]"] \
                [list [export_vars -base course-info {man_id}] \
                    "[_ lorsm.lt_Preview_Course_course]"] \
                "[_ lorsm.Confirmation]"]

set return_url [site_node::get_url_from_object_id -object_id $package_id]
