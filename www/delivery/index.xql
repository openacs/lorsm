<?xml version="1.0"?>
<queryset>

    <fullquery name="manifest">
        <querytext>
            select cp.course_name, cp.fs_package_id, isscorm, pf.folder_name, pf.format_name,
            case when upper(scorm_type) = 'SCO' then 'delivery-scorm'
            else 'delivery'
            end as deliverymethod

            from ims_cp_manifests cp
                left join (select man_id, max(scorm_type) as scorm_type
                            from ims_cp_resources
                            group by man_id ) as cpr using (man_id),
                lorsm_course_presentation_formats pf
            where cp.man_id = :man_id
                and cp.parent_man_id = 0
                and cp.course_presentation_format = pf.format_id
        </querytext>
    </fullquery>

    <fullquery name="enabled_p">
        <querytext>
            select isenabled
            from ims_cp_manifest_class
            where man_id=:man_id
                and community_id=:community_id
        </querytext>
    </fullquery>

</queryset>
