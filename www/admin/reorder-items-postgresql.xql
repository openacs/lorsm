<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_next_sort_order">
<querytext>
select sort_order from ims_cp_items where parent_item=:parent_item and sort_order > :sort_order order by sort_order limit 1
</querytext>
</fullquery>

<fullquery name="get_prev_sort_order">
<querytext>
select sort_order from ims_cp_items where parent_item=:parent_item and sort_order < :sort_order order by sort_order limit 1
</querytext>
</fullquery>

</queryset>