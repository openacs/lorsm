<?xml version="1.0"?>
<queryset>

    <fullquery name="select_d_courses">
        <querytext>
            select
                cp.man_id, cp.course_name, cp.identifier, cp.version, cp.fs_package_id,

                case when cp.fs_package_id is null then 't'
                else 'f'
                end as lorsm_p,

                cp.folder_id, acs.creation_user, acs.creation_date, pf.folder_name,
                pf.format_name, acs.context_id, cpmc.community_id, cpmc.lorsm_instance_id
            from ims_cp_manifests cp, acs_objects acs, ims_cp_manifest_class cpmc, lorsm_course_presentation_formats pf
            where cp.man_id = acs.object_id
                and cp.man_id = cpmc.man_id
                and cpmc.lorsm_instance_id = :package
                and cpmc.isenabled = 't'
                and pf.format_id = cp.course_presentation_format
            order by acs.creation_date desc
        </querytext>
    </fullquery>

    <fullquery name="get_last_viewed">
        <querytext>
            select v.last_viewed
            from views_views v, ims_cp_items i, ims_cp_organizations o
            where v.viewer_id = :user_id
                and v.object_id = i.ims_item_id
                and i.org_id = o.org_id
                and o.man_id = :man_id
            order by v.last_viewed desc
            limit 1
        </querytext>
    </fullquery>

    <fullquery name="get_total_items">
        <querytext>
            select i.ims_item_id
            from ims_cp_items i, ims_cp_organizations o
            where o.man_id = :man_id
                and i.org_id = o.org_id
        </querytext>
    </fullquery>

    <fullquery name="get_viewed_items">
        <querytext>
            select v.object_id
            from views_views v
            where v.viewer_id = :user_id
                and v.object_id in ([join $all_items ,])
        </querytext>
    </fullquery>

    <fullquery name="get_item_id">
        <querytext>
            select item_id
            from cr_revisions
            where revision_id = :man_id
        </querytext>
    </fullquery>

    <fullquery name="query">
        <querytext>
            select cp.man_id,
                case when upper(scorm_type) = 'SCO' then 'delivery-scorm'
                else 'delivery'
                end as needscorte

            from ims_cp_manifests cp left join ( select man_id, max(scorm_type) as scorm_type
                                                 from ims_cp_resources
                                                 group by man_id )
                as cpr using (man_id)
            where cp.man_id = :man_id
        </querytext>
    </fullquery>

    <fullquery name="manifest">
        <querytext>
            select
                cp.course_name,
                cp.fs_package_id,
                isscorm,
                pf.folder_name,
                pf.format_name,
            case when upper(scorm_type) = 'SCO' then 'delivery-scorm'
            else 'delivery'
            end as deliverymethod

            from ims_cp_manifests cp  left join ( select man_id, max(scorm_type) as scorm_type
                                                  from ims_cp_resources
                                                  group by man_id )
                as cpr using (man_id), lorsm_course_presentation_formats pf
            where cp.man_id = :man_id
                and  cp.parent_man_id = 0
                and cp.course_presentation_format = pf.format_id
        </querytext>
    </fullquery>

    <fullquery name="isanysuspendedsession">
        <querytext>
            select lorsm.track_id as track_id, cmi.lesson_status as lesson_status
            from lorsm_student_track lorsm, lorsm_cmi_core cmi
            where lorsm.user_id = $user_id
                and lorsm.community_id = $community_id
                and lorsm.course_id = $man_id
                and lorsm.track_id = cmi.track_id
                and cmi.man_id = $man_id
                and cmi.item_id = $man_id
            order by lorsm.track_id desc
            limit 1
        </querytext>
    </fullquery>

</queryset>
