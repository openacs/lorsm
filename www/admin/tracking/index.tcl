# packages/lorsm/www/tracking/index.tcl

ad_page_contract {

    Student Tracking Index Page

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-05-25
    @arch-tag a5b230ee-0fa7-4e48-be1b-eeae323291e7
    @cvs-id $Id$
} {
    man_id:integer,notnull
    {item_id 0}
    group:optional
} -properties {
} -validate {
} -errors {
}

set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]

set title [list "[_ lorsm.Student_Tracking]"]
set context [list "[_ lorsm.Tracking_1]"]

if {![exists_and_not_null group]} {
    set group 1
}

if {$group eq "1"} {

    template::list::create \
        -name student_track \
        -multirow student_track \
        -actions [list  "[_ lorsm.Summarize]" \
                        [export_vars -base ".?group=0" {man_id item_id}] \
                        "[_ lorsm.lt_Summarize_all_student]"] \
        -key man_id \
        -html {width 50%} \
        -no_data "[_ lorsm.No_Students]" \
        -elements {
            student_name {
                label "[_ lorsm.Student_Name]"
                display_eval {[person::name -person_id $student_name]}
                link_url_eval {[acs_community_member_url -user_id $student_name]}
                link_html {title "[_ lorsm.Students_profile]"}

            } start_time {
                label "[_ lorsm.Start_Course]"
                display_eval {[lc_time_fmt $start_time "%x %T"]}
                html { align center }

            } end_time {
                label "[_ lorsm.Exit_Course]"
                display_eval {[lc_time_fmt $end_time "%x %T"]}
                html { align center }

            } time_spend {
                label "[_ lorsm.Time_Spent]"
                display_eval {[lorsm::dates_calc \
                                -start_date [string range $start_time 0 18] \
                                -end_date [string range $end_time 0 18]]}
                html { align center }
            }
        }

    db_multirow -extend { ims_md_id } student_track select_students {} {
        set ims_md_id $man_id
    }

    template::list::create \
        -name object_views \
        -multirow object_views \
        -elements {
            title {
                label "[_ lorsm.Title_1]"

            } viewer_name {
                label "[_ lorsm.Viewed_By]"

            } views_count {
                label "[_ lorsm.Total_Views]"

            } last_viewed {
                label "[_ lorsm.Last_Viewed_On]"
                display_eval {[lc_time_fmt $last_viewed "%x %X"]}
            }
        }

    if {$item_id} {
        set extra_where " and v.object_id = :item_id"
    } else {
        set extra_where ""
    }

    db_multirow -extend {viewer_name} object_views objects_views {} {
        set viewer_name [acs_user::get_element -user_id $viewer_id -element name]
    }

} else {
    # group display

    template::list::create \
        -name student_track \
        -multirow student_track \
        -key man_id \
        -actions [list "[_ lorsm.Expand]" \
                        [export_vars -base ".?group=1" {man_id item_id}] \
                        "Expand all students"] \
        -html {width 50%} \
        -no_data "[_ lorsm.No_Students]" \
        -elements {
            student_name {
                label "Student Name"
                display_eval {[person::name -person_id $student_name]}
                link_url_eval {[acs_community_member_url -user_id $student_name]}
                link_html {title "Student's profile"}

            } counter {
                label "[_ lorsm.Times_Viewed]"
                html { align center }

            } time_spent {
                label "[_ lorsm.Time_Spent]"
                html { align center }
            }
        }

    db_multirow -extend { ims_md_id } student_track select_students2 {} {
        set ims_md_id $man_id
    }

    template::list::create \
        -name object_views \
        -multirow object_views \
        -elements {
            title {
                label "[_ lorsm.Title_1]"

            } views_count {
                label "[_ lorsm.Total_Views]"

            } unique_views {
                label "[_ lorsm.Unique_Views]"

            } last_viewed {
                label "[_ lorsm.Last_Viewed_On]"
            }
        }

    if {$item_id} {
        set extra_where " and v.object_id = :item_id"
    } else {
        set extra_where ""
    }

    db_multirow object_views objects_views2 {}
}
