<?xml version="1.0"?>
<queryset>

    <fullquery name="manifest">
        <querytext>
            select cp.man_id, cp.course_name, cp.identifier, text 'Yes' as hello,
                case when hasmetadata = 't' then 'Yes'
                else 'No'
                end as man_metadata,

                case when isscorm = 't' then 'Yes'
                else 'No'
                end as isscorm, cp.fs_package_id,

                case
                when fs_package_id is null then 'f'
                else 't'
                end as lorsm_p, cp.folder_id,

                cp.isshared, acs.creation_user, acs.creation_date, acs.context_id,
                cpmc.isenabled, pf.format_pretty_name, cpmc.istrackable
            from ims_cp_manifests cp, acs_objects acs, ims_cp_manifest_class cpmc,
                lorsm_course_presentation_formats pf
            where cp.man_id = acs.object_id
                and  cp.man_id = :man_id
                and  cp.man_id = cpmc.man_id
                and  cpmc.lorsm_instance_id = :package_id
                and  cp.parent_man_id = 0
                and  cp.course_presentation_format = pf.format_id
        </querytext>
    </fullquery>

    <fullquery name="get_versions">
        <querytext>
            select count(revision_id)
            from cr_revisions
            where item_id = ( select item_id
                                from cr_revisions
                                where revision_id = :man_id )
      </querytext>
    </fullquery>

    <fullquery name="get_folder_id">
        <querytext>
            select item_id
            from cr_items
            where name = :instance
                and parent_id = :root_folder
        </querytext>
    </fullquery>

    <fullquery name="submans">
        <querytext>
            select count(*) as submanifests
            from ims_cp_manifests
            where man_id = :man_id
                and parent_man_id = :man_id
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

    <fullquery name="blah">
        <querytext>
            select o.object_id,
                repeat('&nbsp;', (tree_level(tree_sortkey) - :indent)* 3) as indent,
                i.ims_item_id as item_id, i.item_title as item_title, i.hasmetadata, i.org_id,

                case when i.isshared = 'f' then ('false' )
                else 'true'
                end as isshared,

                case when i.identifierref <> '' then
                    ( select res.href
                        from ims_cp_items_to_resources i2r, ims_cp_resources res
                        where i2r.res_id = res.res_id
                            and i2r.ims_item_id = i.ims_item_id )
                else ''
                end as identifierref,

                case when i.identifierref <> '' then
                    ( select res.type
                        from ims_cp_items_to_resources i2r, ims_cp_resources res
                        where i2r.res_id = res.res_id
                            and i2r.ims_item_id = i.ims_item_id )
                else ''
                end as type,

                m.fs_package_id, m.folder_id, m.course_name
            from acs_objects o, ims_cp_items i, ims_cp_manifests m
            where o.object_type = 'ims_item_object'
                and i.org_id = :org_id
                and o.object_id = i.ims_item_id
                and i.ims_item_id =
                    ( select live_revision
                        from cr_items
                        where item_id =
                            ( select item_id
                                from cr_revisions
                                where revision_id = i.ims_item_id ) )
                and m.man_id = :man_id
            order by tree_sortkey, object_id
        </querytext>
    </fullquery>

    <fullquery name="get_custom_pages">
        <querytext>
            select i.ims_item_id, i.item_title, lcp.type, ci.item_id
            from lorsm_custom_pages lcp, ims_cp_manifests m, ims_cp_organizations o, ims_cp_items i, cr_items ci
            where ci.item_id=lcp.page_id
                and m.man_id=:man_id
                and m.man_id=o.man_id
                and o.org_id=i.org_id
                and i.ims_item_id=ci.live_revision
        </querytext>
    </fullquery>

</queryset>
