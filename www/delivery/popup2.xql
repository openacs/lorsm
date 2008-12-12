<?xml version="1.0"?>
<queryset>

    <fullquery name="manifest">
        <querytext>
            select cp.course_name, cp.fs_package_id
            from ims_cp_manifests cp
            where cp.man_id = :man_id
                and cp.parent_man_id = 0
        </querytext>
    </fullquery>

</queryset>
