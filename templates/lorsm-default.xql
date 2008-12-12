<?xml version="1.0"?>
<queryset>

    <fullquery name="get_man_id">
        <querytext>
            select man_id
            from ims_cp_items i, ims_cp_organizations o
            where i.ims_item_id = :imsitem_id
                and i.org_id = o.org_id
        </querytext>
    </fullquery>

    <fullquery name="get_folder__id">
        <querytext>
            select folder_id
            from ims_cp_manifests
            where man_id = :man_id
        </querytext>
    </fullquery>

    <fullquery name="item_info">
        <querytext>
            select item_title, parent_item
            from ims_cp_items
            where ims_item_id = :imsitem_id
        </querytext>
    </fullquery>

    <fullquery name="children">
        <querytext>
            select ims_cp_items.ims_item_id as child_item_id,
                ims_cp_items.item_title as child_title
            from acs_objects, ims_cp_items
            where acs_objects.object_id = ims_cp_items.ims_item_id
                and parent_item = :imsitem_id
            order by acs_objects.object_id, acs_objects.tree_sortkey
        </querytext>
    </fullquery>

    <fullquery name="grandchildren">
        <querytext>
            select count(*)
            from ims_cp_items
            where parent_item = :extracted_sql_children
        </querytext>
    </fullquery>

    <fullquery name="siblings">
        <querytext>
            select count(*)
            from ims_cp_items
            where parent_item = :parent_item
        </querytext>
    </fullquery>

    <fullquery name="grandparent">
        <querytext>
            select ims_cp_items.parent_item as grandparent_item,
                ims_cp_resources.href as grandparent_href
            from ims_cp_items, ims_cp_resources, ims_cp_items_to_resources
            where ims_cp_items.ims_item_id = :parent_item
                and ims_cp_items.parent_item = ims_cp_items_to_resources.ims_item_id
                and ims_cp_items_to_resources.res_id = ims_cp_resources.res_id
        </querytext>
    </fullquery>

    <fullquery name="href">
        <querytext>
            select href as parent_href
            from ims_cp_resources r, ims_cp_items_to_resources ir
            where ir.ims_item_id = :parent_item
                and ir.res_id = r.res_id
        </querytext>
    </fullquery>

</queryset>
