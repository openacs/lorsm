<?xml version="1.0"?>
<queryset>

<fullquery name="get_man_id">
  <querytext>
    select 
            man_id
    from 
            ims_cp_organizations o, ims_cp_items i
    where 
	    ims_item_id=:item_id
            and o.org_id=i.org_id
  </querytext>
</fullquery>

<fullquery name="get_item_sort_and_parent">
  <querytext>
    select 
            sort_order, parent_item
    from 
            ims_cp_items
    where 
            ims_item_id = :ims_item_id
  </querytext>
</fullquery>

</queryset>

