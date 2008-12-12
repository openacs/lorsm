<?xml version="1.0"?>
<queryset>

    <fullquery name="get_org_id">
        <querytext>
            select org_id
            from ims_cp_organizations
            where man_id = :man_id
        </querytext>
    </fullquery>

    <fullquery name="organizations">
        <querytext>
            select org.org_id, org.org_title as org_title, org.hasmetadata, man_id,
                tree_level(o.tree_sortkey) as indent
            from ims_cp_organizations org, acs_objects o
            where org.org_id = o.object_id
                and man_id = :man_id
            order by org_id
      </querytext>
    </fullquery>

    <fullquery name="get_fs_package_id">
        <querytext>
            select fs_package_id
            from ims_cp_manifests
            where man_id = :man_id
        </querytext>
    </fullquery>

    <fullquery name="get_items_count">
        <querytext>
            select count(ims_item_id)
            from ims_cp_items
            where ims_item_id in ( select live_revision
                                    from cr_items
                                    where content_type = 'ims_item_object')
                and org_id = :org_id
        </querytext>
    </fullquery>

    <fullquery name="get_root_item">
        <querytext>
            select ims_item_id
            from ims_cp_items
            where parent_item = :org_id
                and org_id = :org_id
        </querytext>
    </fullquery>

    <fullquery name="get_items">
        <querytext>
            select ims_item_id
            from ims_cp_items
            where parent_item = :item_id
                and org_id = :org_id
        </querytext>
    </fullquery>

    <fullquery name="sql">
        <querytext>
            select
                -- (tree_level(ci.tree_sortkey) - :indent ) as indent,
                i.parent_item, i.ims_item_id, i.item_title as item_title,
                i.prerequisites_s as prerequisites, cr.mime_type
            from acs_objects o, ims_cp_items i, cr_items ci,
                cr_revisions cr, ims_cp_manifest_class im
            where o.object_type = 'ims_item_object'
                and i.org_id = :org_id
                and o.object_id = i.ims_item_id
                and im.man_id=:man_id
                and im.isenabled='t'
                and im.community_id=:community_id
                and ci.item_id=cr.item_id
                and cr.revision_id=i.ims_item_id
                and exists
                    (select 1
                    from acs_object_party_privilege_map p
                    where p.object_id = i.ims_item_id
                        and p.party_id = :user_id
                        and p.privilege = 'read')
            order by i.sort_order, o.object_id, ci.tree_sortkey
        </querytext>
    </fullquery>

    <fullquery name="isnotanemptyitem">
        <querytext>
            select res_id
            from ims_cp_items_to_resources
            where ims_item_id= $item_id
            limit 1
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
                and cmi.item_id = $item_id
            order by lorsm.track_id desc
            limit 1
        </querytext>
    </fullquery>

    <fullquery name="givemeid">
        <querytext>
            select i.ims_item_id as id_from_ref
            from ims_cp_items i, ims_cp_manifest_class im, ims_cp_organizations o
            where i.identifier=:prer
                and o.org_id = i.org_id
                and o.man_id = :man_id
                and im.man_id= :man_id
                and im.isenabled='t'
                and im.community_id=:community_id
        </querytext>
    </fullquery>

    <fullquery name="isanysuspendedsession2">
        <querytext>
            select lorsm.track_id as track_id, cmi.lesson_status as lex_status
            from lorsm_student_track lorsm, lorsm_cmi_core cmi
            where lorsm.user_id = $user_id
                and lorsm.community_id = $community_id
                and lorsm.course_id = $man_id
                and lorsm.track_id = cmi.track_id
                and cmi.man_id = $man_id
                and cmi.item_id = $id_from_ref
            order by lorsm.track_id desc
        </querytext>
    </fullquery>

    <fullquery name="isanysuspendedsession3">
        <querytext>
            select lorsm.track_id as track_id, cmi.lesson_status as lesson_status
            from lorsm_student_track lorsm, lorsm_cmi_core cmi
            where lorsm.user_id = $user_id
                and lorsm.community_id = $community_id
                and lorsm.course_id = $man_id
                and lorsm.track_id = cmi.track_id
                and cmi.man_id = $man_id
                and cmi.item_id = $item_id
            order by lorsm.track_id desc
        </querytext>
    </fullquery>

</queryset>
