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
            select org.org_id, org.org_title as org_title, org.hasmetadata,
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

    <fullquery name="sql">
        <querytext>
            select i.parent_item, i.ims_item_id, i.item_title as item_title
            from ims_cp_items i, cr_items ci, cr_revisions cr
            where i.org_id = :org_id
                and ci.item_id=cr.item_id
                and cr.revision_id=i.ims_item_id
                and exists (select 1
                            from acs_object_party_privilege_map p
                            where p.object_id = i.ims_item_id
                                and p.party_id = :user_id
                                and p.privilege = 'read')
            order by i.sort_order,ci.tree_sortkey
        </querytext>
    </fullquery>

</queryset>
