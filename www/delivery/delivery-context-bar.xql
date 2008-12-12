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

    <fullquery name="get_title_prev">
        <querytext>
            select item_title
            from ims_cp_items
            where ims_item_id=:prev_item_id
        </querytext>
    </fullquery>

    <fullquery name="get_title_next">
        <querytext>
            select item_title
            from ims_cp_items
            where ims_item_id=:next_item_id
        </querytext>
    </fullquery>

    <fullquery name="get_title_current">
        <querytext>
            select item_title
            from ims_cp_items
            where ims_item_id=:last_item_viewed
        </querytext>
    </fullquery>

</queryset>
