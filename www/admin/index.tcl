# packages/lorsm/www/index.tcl

ad_page_contract {
    Learning Object Repository Management Index page

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 19 January 2003
    @cvs-id $Id$

} {
}

set title "[_ lorsm.lt_Manage_Courses_in_Rep]"
set context [list "[_ lorsm.Manage_Courses]"]


set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set community_id [lors::get_community_id]

set actions [list]

lappend actions     "[_ lorsm.Add_Course]" \
                    [export_vars -base "course-add"] \
                    "[_ lorsm.lt_Add_a_IMSSCORM_Compli]"

lappend actions     "[_ lorsm.lt_Search_Learning_Objec]" \
                    [export_vars -base "/search"] \
                    "[_ lorsm.lt_Search_for_Learninng_]"

lappend actions     "[_ lorsm.Available_Courses]" \
                    [export_vars -base "shared/"] \
                    "[_ lorsm.lt_View_Available_Course]"

template::list::create \
    -name d_courses \
    -multirow d_courses \
    -html {width 50%} \
    -actions $actions \
    -key man_id \
    -no_data "[_ lorsm.No_Courses]" \
    -elements {
        course_name {
            label "[_ lorsm.Available_Courses]"
            display_template {@d_courses.course_url;noquote@}
            display_col course_name
            link_html {title "Access Course"}

        } hasmetadata {
            label "[_ lorsm.Metadata_1]"
            display_template {
                <if @d_courses.lorsm_p@>
                    <div style="text-align: center;">
                        <a href="md/?ims_md_id=@d_courses.ims_md_id@" title="[_ lorsm.See_metadata]">@d_courses.hasmetadata@</a>
                    </div>
                </if>
                <else>
                    <div style="text-align:center;"> @d_courses.hasmetadata@</div>
                </else>
            }

        } isscorm {
            label "[_ lorsm.SCORM]"
            html { align center }

        } isenabled {
            label "[_ lorsm.Status_1]"
            html { align center }

        } istrackable {
            label "[_ lorsm.Tracking]"
            link_url_eval {tracking/?[export_vars man_id]}
            link_html {title "[_ lorsm.lt_Track_Students_Progre]" class button}
            html { align center }

        } deliverymethod {
            label "[_ lorsm.Default_delivery]"
            html { align center }

        } hasrtedata {
            label "[_ lorsm.SCORM_session]"
            display_template {
            <if @d_courses.hasrtedata@>
                <div style="text-align:center;">
                    <a href="tracking-rte/?man_id=@d_courses.man_id@" title="[_ lorsm.Sesion_Runtime_Data]">@d_courses.hasrtedata@</a>
                </div>
            </if>
            }

        } creation_user {
            label "[_ lorsm.Owner]"
            display_eval {[person::name -person_id $creation_user]}
            link_url_eval {[acs_community_member_url -user_id $creation_user]}

        } creation_date {
            label "[_ lorsm.Creation_Date]"
            display_eval {[lc_time_fmt $creation_date "%x %X"]}

        } export {
            label "[_ lorsm.Export]"
            display_template {
                <if @d_courses.lorsm_p@>
                    <div style="text-align:center;">
                        <a href="export/?folder_id=@d_courses.folder_id@" title="[_ lorsm.lt_Export_as_IMS_Content]">\[zip\]</a>
                    </div>
                </if>
            }

        } admin {
            label "[_ lorsm.Admin_Course]"
            display_eval {Admin}
            link_url_eval {[export_vars -base course-structure man_id]}
            link_html {title "[_ lorsm.Admin_Course]" class button}
            html { align center }

        } permissions {
            label "Permissions"
            display_eval {Permissions}
            link_url_eval {[export_vars -base /permissions/one {{object_id $man_id}}]}
            link_html {class button}
        }
    }


db_multirow -extend { ims_md_id course_url } d_courses select_d_courses {} {
    set ims_md_id $man_id
#    if { [string eq $format_name "default"] } {
    set course_url "<a href=\"[ad_conn package_url]delivery/?[export_vars man_id]\" title=\"[_ lorsm.Access_Course]\">$course_name</a>"
 #   } else {
#   set course_url "<a href=\"${folder_name}/?[export_vars man_id]\" title=\"[_ lorsm.Access_Course]\" target=_blank>$course_name</a>"
#    }
}

