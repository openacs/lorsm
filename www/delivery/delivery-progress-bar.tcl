# packages/lorsm/www/delivery/delivery-context-bar.tcl

ad_page_contract {

} {
    {__include ""}
    {__include_vars ""}
    {next_item_id ""}
    track_id:optional
} -properties {
} -validate {
} -errors {
}

if {![info exists man_id] || $man_id eq ""} {
    set man_id [ad_get_client_property lorsm man_id]
}

if {![info exists item_id]} {
    set item_id [ad_get_client_property lorsm ims_id]
}
ns_log notice "delivery progress bar DEBUG:: item_id $item_id"
set community_id [dotlrn_community::get_community_id]
set user_id [ad_conn user_id]

set track_id [lorsm::track::get_track_id \
                -user_id $user_id \
                -man_id $man_id \
                -community_id $community_id]

#ns_log notice "DAVEB LORSM BEFORE TRACK_ID='${track_id}'"
set lorsm_url [dotlrn_community::get_community_url $community_id]lorsm/delivery

set package_id [site_node::get_element -url $lorsm_url -element package_id]

# return_url
set return_url [dotlrn_community::get_community_url [dotlrn_community::get_community_id]]

set item_list [lorsm::get_item_list $man_id $user_id]
set first_item_id [lindex $item_list 0]
set first_item_url "<a href=\"[export_vars \
                                -base "${lorsm_url}/record-view" \
                                -url {{item_id $first_item_id} man_id}]\">
                                        <img src=\"${lorsm_url}/Images/home.png\"
                                            border=\"0\"
                                            title=\"home\"
                                            onclick=\"window.location.reload()\"></a>"

set curr_index [expr [lsearch -exact $item_list $item_id]]
set next_link_text [_ lorsm.Next]

set track_p 1

if {$curr_index < 0} {
    set lorsm_return_url [get_referrer]
    ad_set_client_property lorsm lorsm_return_url $lorsm_return_url

    if {$track_id ne "" && $track_id ne "0"} {
        set last_viewed_item_id [db_string get_last_viewed \
                                    "select object_id
                                    from views_views, lorsm_student_track
                                    where viewer_id = :user_id
                                        and object_id in ([template::util::tcl_to_sql_list $item_list])
                                        and track_id=:track_id
                                        and last_viewed > start_time
                                    order by last_viewed desc
                                    limit 1" -default ""]

        if {$last_viewed_item_id ne ""} {
            set item_id $last_viewed_item_id
            ad_set_client_property lorsm ims_id $item_id
            ad_returnredirect [export_vars \
                                -base "${lorsm_url}/record-view" \
                                -url {{item_id $item_id} track_id man_id}]
            ad_script_abort
        }
    }

    # start course
    # we want the next_url to be the first item
    set curr_index -1
    # do we have a custom start page?
    set item_id [lorsm::get_custom_page_ims_item_id -man_id $man_id -type start]
    if {$item_id eq ""} {
        set __include "/packages/lorsm/lib/start"
        set page_title [lorsm::get_course_name -manifest_id $man_id]
    } else {
        ad_set_client_property lorsm ims_id $item_id
        set __include /packages/lorsm/lib/default
        set page_title [db_string get_title \
                            "select item_title
                            from ims_cp_items
                            where ims_item_id=:item_id" -default ""]
    }

    set next_link_text [_ lorsm.Begin]
    if {$track_id ne ""} {
        set next_link_text [_ lorsm.Continue]
    }
    set track_p 0
}

# Student tracking
if {[lorsm::track::istrackable \
        -course_id $man_id \
        -package_id $package_id] \
    && $track_p && ($track_id == 0 || $track_id eq "")} {

    set track_id [lorsm::track::new \
                    -user_id $user_id \
                    -community_id $community_id \
                    -course_id $man_id]
    ad_set_client_property lorsm studenttrack $track_id
} elseif {$track_id eq ""} {
    set track_id 0
}
#ns_log notice "DAVEB LORSM AFTER TRACK_ID='${track_id}'"

if {$track_id ne "0"} {
    lorsm::track::update_elapsed_seconds -track_id $track_id
}

set prev_item_id [lindex $item_list [expr $curr_index - 1]]
set next_item_id [lindex $item_list [expr $curr_index + 1]]
set prev_url "<a href=\"[export_vars \
                            -base "${lorsm_url}/record-view" \
                            -url {{item_id $prev_item_id} man_id}]\">
                                        <img src=\"${lorsm_url}/Images/prev.png\"
                                            border=\"0\"
                                            title=\"next\"
                                            onclick=\"window.location.reload()\"></a>"

set next_url [export_vars \
                -base "${lorsm_url}/record-view" \
                -url {{item_id $next_item_id} track_id man_id}]

set prev_title [db_string get_title \
                    "select item_title
                    from ims_cp_items
                    where ims_item_id=:prev_item_id" -default ""]

set next_title [db_string get_title \
                    "select item_title
                    from ims_cp_items
                    where ims_item_id=:next_item_id" -default ""]

set current_title [db_string get_title \
                    "select item_title
                    from ims_cp_items
                    where ims_item_id=:item_id" -default ""]

set progress_total_pages [llength $item_list]
set progress_current_page [expr {$curr_index + 1}]
set last_item_p [expr {$curr_index == [expr {[llength $item_list] - 1}]}]
if {[string match "*assessment*" $__include] && \
        ![string match "*assessment/lib/session*" $__include]} {
    set show_next 0
    template::head::add_css \
        -href "/resources/assessment/crbForms.css"
    template::head::add_css \
        -href "/resources/assessment/assessment.css"
    set last_item_p 0
} else {
    if { $next_item_id eq "" } {
    # check for end page
        set next_url ${lorsm_url}/end
        set last_item_p 0
    }
    set show_next 1
}

if {$__include eq "/packages/lorsm/lib/end"} {
    if {$track_id ne "0"} {
        ns_log notice "HEY PROGRESS BAR END GOING TO TRACK $track_id"
        lorsm::track::exit -track_id $track_id
    }

    set item_id [lorsm::get_custom_page_ims_item_id -man_id $man_id -type end]
    if {$item_id ne ""} {
        ad_set_client_property lorsm ims_id $item_id
        set __include /packages/lorsm/lib/default
        set page_title [db_string get_title "select item_title from ims_cp_items where ims_item_id=:item_id" -default ""]
    }

    set lorsm_return_url [ad_get_client_property lorsm lorsm_return_url]
    if {$lorsm_return_url ne ""} {
        set return_url $lorsm_return_url
    }
    set next_url [export_vars -base exit {man_id track_id return_url}]
    set last_item_p 1
}

if {$item_id eq "" && $__include ne "/packages/lorsm/lib/start" \
        && $__include ne "/packages/lorsm/lib/end"} {
    ad_returnredirect \
        -message "[_ lorsm.This_course_contains_no_items]" \
        [get_referrer]
    ad_script_abort
}
set include_content [template::adp_include $__include $__include_vars]
regsub -all {<a(.*?)>} $include_content {<a target=\"_new\" \1 >} include_content

if {$current_title ne ""} {
    set page_title $current_title
}


if {[info exists ::js_order]} {
    foreach js $::js_order {
        template::head::add_script -src $js
    }
}


template::head::add_style -style \
    ".current-item {
        font-weight: bold;
        font-size: 1.2em;
    }

    .next-button {
        margin: 4px;
        padding-left: 4px;
        padding-right: 4px;
        border-top: 2px solid #fff;
        border-left: 2px solid #fff;
        border-right: 2px solid #999;
        border-bottom: 2px solid #999;
        background-color: #eee;
    }

    .next-button a {
        text-decoration: none;
        color: black;
        font-size: .8em;
        font-family: sans-serif;
    }"
