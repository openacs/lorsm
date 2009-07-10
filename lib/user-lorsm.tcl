set user_id [ad_conn user_id]
set our_community_id [lors::get_community_id]
set return_url [ad_return_url]

set lors_central_package_id [apm_package_id_from_key "lors-central"]
set lors_central_url [apm_package_url_from_id $lors_central_package_id]

set add_subject_p 0
foreach package $package_id {
    db_multirow \
        -extend { admin_p item_id ims_md_id last_viewed \
            total_item_count viewed_item_count viewed_percent course_url \
            lesson_status community_name community_url
        } -append d_courses select_d_courses { } {
            if { $community_id != $our_community_id } {
                set add_subject_p 1
                set community_node_id [lors::get_community_node_id -community_id $community_id]
                set community_name [lors::get_community_name -node_id $community_node_id]
                set community_url [lors::get_community_url -node_id $community_node_id]
            }
            set ims_md_id $man_id

            if { [string eq $format_name "default"] } {

                # micheles
                set context [site_node::get_url_from_object_id \
                                -object_id $lorsm_instance_id]
                if ([db_0or1row query {}]) {
                    ns_log Debug "lorsm - $needscorte"
                    set delivery_method delivery
                    set course_url_url [export_vars \
                        -base "[lindex $context 0]$delivery_method/" \
                        -url {man_id return_url}]

                    #this popup shouldn't affect delivery should popup blocker be in place
                    if { [string eq $needscorte "delivery-scorm"] } {
                        set course_url "> <a href=\"[ad_quotehtml $course_url_url]\"
                            onclick=\"return popupnr(\'[ad_quotehtml $course_url_url]\',\'aaa\',1);\"
                            title=\"[_ lorsm.Access_Course]\">$course_name</a>"
                    } else {
                        set course_url "<a href=\"[ad_quotehtml $course_url_url]\"
                            title=\"[_ lorsm.Access_Course]\">$course_name</a>"
                    }
                    ns_log Debug "lorsm - course_url: $course_url"

                } else {
                    set course_url "NO RESOURCES ERROR"
                }
            } else {
                set course_url "<a href=\"[site_node::get_url_from_object_id \
                    -object_id $lorsm_instance_id]delivery/?[ad_quotehtml[export_vars {man_id return_url}]]\"
                    title=\"[_ lorsm.Access_Course]\" >$course_name</a>"
            }

            #LET's CHECK IF delivery is RTE, so there should be some tracking.
            #the code, differentely than above, check the delivery method as per above

            # Get the course name
            if {[db_0or1row manifest {}]} {
                # Course Name
                if {[empty_string_p $course_name]} {
                    set course_name "No Course Name"
                }
            } else {
                set course_name "No Course Name"
            }

            set lesson_status "N/A"

            if { [string equal $deliverymethod "delivery-scorm"] } {
                set icon ""
                if { ! [ db_0or1row isanysuspendedsession {} ] } {
                    #item has no track for the user
                    #the icon should be the same as per "not yet visited"
                    append icon "<img src=\"/resources/lorsm/icons/flag_white.gif\"
                        alt=\"#lorsm.Not_attempted#\">"
                } else {
                    switch -regexp $lesson_status {
                        null {
                            append icon "<img src=\"/resources/lorsm/icons/flag_white.gif\" alt=\"#lorsm.Not_attempted#\">"

                        } incomplete {
                            append icon "<img src=\"/resources/lorsm/icons/flag_orange.gif\" alt=\"#lorsm.Incomplete#\">"

                        } complete {
                            append icon "<img src=\"/resources/lorsm/icons/flag_green.gif\" alt=\"#lorsm.Completed#\">"

                        } failed {
                            append icon "<img src=\"/resources/lorsm/icons/flag_red.gif\" alt=\"#lorsm.Failed#\">"

                        } "not attempted" {
                            append icon "<img src=\"/resources/lorsm/icons/flag_white.gif\" alt=\"#lorsm.Not_attempted#\">"

                        } passed {
                            append icon "<img src=\"/resources/lorsm/icons/icon_accept.gif\" alt=\"#lorsm.Passed#\">"
                        } default {
                            append icon "<span style=\"color: #fff\"> $lesson_status
                                **</span> <img src=\"/resources/lorsm/icons/flag_blue.gif\" alt=\"$lesson_status\">"
                        }
                    }
                }
                set lesson_status $icon
            }

            # DEDS: these are expensive
            # and for demo purposes only

            db_0or1row get_last_viewed { }
            set all_items [db_list get_total_items { }]
            set total_item_count [llength $all_items]
            if {$total_item_count > 0} {
                set viewed_items [db_list get_viewed_items { }]
            } else {
                set viewed_items {}
            }
                set viewed_item_count [llength $viewed_items]

            ns_log Debug "lorsm - viewed_item_count: $viewed_item_count"

            if { $total_item_count == 0 } {
                set viewed_percent 0
            } else {
                set viewed_percent [expr \
                    [expr $viewed_item_count * 1.00] / $total_item_count * 100]
            }

            set item_id [db_string get_item_id { }]
            set admin_p [permission::permission_p \
                            -party_id $user_id \
                            -object_id $item_id \
                            -privilege "admin"]
        }
}

set elements_list {
    course_name {
        label "[_ lorsm.Course_Name_1]"
        display_template {
            @d_courses.course_url;noquote@
            <if @lors_central_p eq 0>
                <if @d_courses.admin_p@>
                    <i>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="${lors_central_url}one-course?item_id=
                            @d_courses.item_id@">#lors-central.add_mat#</a>
                    </i>
                </if>
            </if>
        }
        html { style "width:70%" }
    }
}

if { $add_subject_p } {
    append elements_list {
        subject {
            label "[_ lorsm.Subject]"
            display_eval { $community_name }
            html { align center style "width:20%" }
            link_url_eval { $community_url }
            link_html {title "[_ lorsm.Access_Course]"}
        }
    }
}

append elements_list {
    last_viewed {
        label "[_ lorsm.Last_Viewed_On]"
        html { align center style "width:10%" }
        display_eval {[lc_time_fmt $last_viewed "%x"]}

    } viewed_percent {
        label "[_ lorsm._Viewed]"
        html { align right }
        display_eval {[lc_numeric $viewed_percent "%.2f"]}
    } lesson_status {
        label "[_ lorsm.Status_1]"
        html { align center }
        display_template { @d_courses.lesson_status;noquote@ }
    }
}


if { ![string equal $lors_central_package_id 0] && ![empty_string_p $our_community_id] } {
    if { [lors_central::check_inst -user_id $user_id -community_id $our_community_id] } {
        append elements_list "
            grant_permissions {
                label \"[_ lors-central.grant_permissions]\"
                display_template {
                    <center>
                        <a href=\"${lors_central_url}lc-admin/grant-user-list?
                            man_id=@d_courses.item_id@&
                            creation_user=@d_courses.creation_user@\">
                            [_ lors-central.manage]
                        </a>
                    </center>
                }
            }"

    } else {
        set lors_central_p 0
    }
    set lors_central_p 1
} else {
        set lors_central_p 0
}

template::list::create \
    -name d_courses \
    -multirow d_courses \
    -html {width 100%} \
    -key man_id \
    -no_data "[_ lorsm.No_Courses]" \
    -elements $elements_list


