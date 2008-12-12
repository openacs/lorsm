<?xml version="1.0"?>
<queryset>

    <fullquery name="select_d_courses">
        <querytext>
            select cp.man_id, cp.course_name, cp.identifier, cp.version,
                case when cp.hasmetadata = 't' then 'Yes'
                else 'No'
                end as hasmetadata,

                case when isscorm = 't' then 'Yes'
                else 'No'
                end as isscorm, cp.fs_package_id,

                case when fs_package_id is null then 'f'
                else 't'
                end as lorsm_p,

                cp.folder_id, acs.creation_user, acs.creation_date, pf.folder_name,
                pf.format_name, acs.context_id,

                case when cpmc.isenabled = 't' then 'Enabled'
                else 'Disabled'
                end as isenabled,

                case when cpmc.istrackable = 't' then 'Yes'
                else 'No'
                end as istrackable,

                -- micheles
                -- addition for rte stuff
                --     'Click here' as hasrtedata,
                case when upper(scorm_type) = 'SCO' then 'Click here'
                else ''
                end as hasrtedata,

                case when upper(scorm_type) = 'SCO' then 'delivery-scorm'
                else 'delivery'
                end as deliverymethod

            from acs_objects acs, ims_cp_manifest_class cpmc, lorsm_course_presentation_formats pf,
                -- micheles
                ims_cp_manifests cp left join ( select man_id, max(scorm_type) as scorm_type
                                                from ims_cp_resources
                                                group by man_id ) as cpr using (man_id)

            where cp.man_id = acs.object_id
                and cp.man_id = cpmc.man_id
                and cpmc.community_id = :community_id
                and cp.course_presentation_format = pf.format_id
                and cp.man_id in ( select cr.live_revision
                                    from cr_items cr
                                    where content_type = 'ims_manifest_object')

            order by acs.creation_date desc, cp.man_id asc
        </querytext>
    </fullquery>

</queryset>
