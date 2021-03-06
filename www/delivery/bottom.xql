<?xml version="1.0"?>
<queryset>

    <fullquery name="select_last_item_viewed">
        <querytext>
            select ims_item_id
            from views_views v, ims_cp_items i, ims_cp_organizations o
            where v.viewer_id = :user_id
                and v.object_id = i.ims_item_id
                and i.org_id = o.org_id
                and o.man_id = :man_id
            order by v.last_viewed desc
            limit 1
        </querytext>
    </fullquery>

</queryset>
