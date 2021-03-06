<?xml version="1.0"?>
<queryset>

    <fullquery name="get_man_id">
        <querytext>
            select man_id
            from ims_cp_organizations o, ims_cp_items i
            where ims_item_id=:item_id
                and o.org_id=i.org_id
      </querytext>
    </fullquery>

    <fullquery name="get_item_sort_and_parent">
        <querytext>
            select sort_order, parent_item
            from ims_cp_items
            where ims_item_id = :ims_item_id
      </querytext>
    </fullquery>

    <fullquery name="get_next_sort_order">
        <querytext>
            select sort_order
            from ims_cp_items
            where parent_item=:parent_item
                and sort_order > :sort_order
            order by sort_order
            limit 1
        </querytext>
    </fullquery>

    <fullquery name="get_prev_sort_order">
        <querytext>
            select sort_order
            from ims_cp_items
            where parent_item=:parent_item
                and sort_order < :sort_order
                order by sort_order desc
            limit 1
        </querytext>
    </fullquery>

    <fullquery name="lock_rows">
        <querytext>
            select ims_item_id
            from ims_cp_items
            where parent_item=:parent_item for update
        </querytext>
    </fullquery>

    <fullquery name="swap_sort_orders">
        <querytext>
            update ims_cp_items
                set sort_order =
                    ( case when sort_order = :sort_order :: integer then :next_sort_order :: integer
                        when sort_order = :next_sort_order ::integer then :sort_order end )
            where parent_item=:parent_item
                and sort_order in (:sort_order, :next_sort_order)
        </querytext>
    </fullquery>

</queryset>

