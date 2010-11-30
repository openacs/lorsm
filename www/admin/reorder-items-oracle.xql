<?xml version="1.0"?>
<queryset>
    <rdbms><type>oracle</type><version>8.1.7</version></rdbms>
    <fullquery name="get_next_sort_order">
      <querytext>
        select sort_order
        from (select sort_order
                from ims_cp_items
                where parent_item=:parent_item
                    and sort_order > :sort_order
                    order by sort_order) s
        where s.rownum = 1
      </querytext>
    </fullquery>

    <fullquery name="get_prev_sort_order">
      <querytext>
        select sort_order
        from (select sort_order
                from ims_cp_items
                where parent_item=:parent_item
                    and sort_order < :sort_order
                    order by sort_order desc) s

        where s.rownum = 1
      </querytext>
    </fullquery>

</queryset>
