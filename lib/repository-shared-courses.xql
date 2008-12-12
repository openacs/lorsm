<?xml version="1.0"?>
<queryset>

    <fullquery name="select_d_courses">
        <querytext>
            select cp.man_id, cp.course_name, cp.identifier, cp.version,

                case when hasmetadata = 't' then 'Yes'
                else 'No'
                end as hasmetadata,

                cp.fs_package_id, cp.folder_id, acs.creation_user, acs.creation_date, acs.context_id
            from ims_cp_manifests cp, acs_objects acs
            where cp.man_id = acs.object_id
                and cp.isshared = 't'
                and cp.man_id in ( select cr.live_revision
                                    from cr_items cr
                                    where content_type = 'ims_manifest_object' )
            order by acs.creation_date desc
        </querytext>
    </fullquery>

</queryset>
