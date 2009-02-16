<?xml version="1.0"?>
<queryset>

    <fullquery name="dbqd.templates.lorsm-no-index.get_imsitem_id">
        <querytext>
            select map.item_id as viewed_item_id, o.man_id
            from ims_cp_items_to_resources map, ims_cp_files f, ims_cp_organizations o, ims_cp_items i
            where f.file_id = :item_id
                and f.res_id = map.res_id
                and map.item_id = i.item_id
                and i.org_id = o.org_id
        </querytext>
    </fullquery>

    <fullquery name="dbqd.templates.lorsm-no-index.select_last_item_viewed">
        <querytext>
            select item_id
            from views_views v, ims_cp_items i, ims_cp_organizations o
            where v.viewer_id = :user_id
                and v.object_id = i.item_id
                and i.org_id = o.org_id
                and o.man_id = :man_id
            order by v.last_viewed desc
            limit 1
        </querytext>
    </fullquery>

</queryset>
