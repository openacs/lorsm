<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>
<fullquery name="get_last_viewed">
  <querytext>
	select ims_item_id as imsitem_id, coalesce(ims_item__get_title(object_id),'Item '||object_id) as last_page_viewed
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