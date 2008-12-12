<?xml version="1.0"?>
<queryset>

    <fullquery name="organizations">
        <querytext>
            select org.org_id, org.org_title as org_title, org.hasmetadata,
                tree_level(o.tree_sortkey) as indent
            from ims_cp_organizations org, acs_objects o
            where org.org_id = o.object_id
                and man_id = :man_id
            order by org_id
        </querytext>
    </fullquery>

    <fullquery name="organization_item">
        <querytext>
            select o.object_id,
                repeat('&nbsp;', (tree_level(tree_sortkey) - :indent)* 2) as indent,
                i.item_id, i.item_title as item_title, i.hasmetadata,
                i.item_id as identifierref,
                i.type, i.org_id, m.fs_package_id, m.folder_id, m.course_name
            from acs_objects o, ims_cp_items i, ims_cp_manifests m
            where o.object_type = 'ims_item'
                and i.org_id = :org_id
                and o.object_id = i.item_id
                and m.man_id = :man_id
            order by object_id, tree_sortkey
        </querytext>
    </fullquery>

    <fullquery name="student_activity">
        <querytext>
            select *
            from lorsm_student_track lorsm, lorsm_cmi_core cmi, ims_cp_manifests manif, ims_cp_items imsitems
            where lorsm.community_id=:community_id
                and lorsm.track_id=cmi.track_id
                and lorsm.course_id=:man_id
                and manif.man_id=:man_id
                and cmi.man_id=:man_id
                and cmi.item_id=:identifierref
                and user_id=:user_id
                and imsitems.ims_item_id=cmi.item_id
            order by cmi.track_id asc
        </querytext>
    </fullquery>

</queryset>
