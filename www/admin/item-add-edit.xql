<?xml version="1.0">
<queryset>

<fullquery name="get_title">
    <querytext>
       select item_title 
       from ims_cp_items 
       where ims_item_id=(select live_revision from cr_items 
                          where item_id=:item_id)
    </querytext>
</fullquery>

<fullquery name="get_org_id">
    <querytext>
        select org_id from ims_cp_organizations where man_id=:man_id
    </querytext>
</fullquery>

<fullquery name="get_folder_id">
    <querytext>
        select parent_id from cr_items where latest_revision=:org_id
    </querytext>
</fullquery>

<fullquery name="set_sort_order">
    <querytext>
        update ims_cp_items 
       set sort_order = (select coalesce(max(sort_order),0) +1 
       from ims_cp_items where org_id=:org_id) 
       where ims_item_id = :ims_item_id
    </querytext>
</fullquery>

<fullquery name="get_storage_type">
    <querytext>
        select storage_type from cr_items where item_id=:item_id
    </querytext>
</fullquery>

<fullquery name="set_title">
    <querytext>
       update ims_cp_items set item_title=:title where ims_item_id=:ims_item_id
    </querytext>
</fullquery>

</queryset>
