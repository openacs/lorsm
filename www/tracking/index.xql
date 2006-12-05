<?xml version="1.0"?>
<queryset>

<fullquery name="objects_views1">
  <querytext>
	select v.object_id,v.viewer_id,v.views_count,v.last_viewed,
               i.item_title as title
        from views_views v,
             ims_cp_items i,
             ims_cp_organizations o
        where
             i.ims_item_id = v.object_id
        and
             i.org_id = o.org_id
	and
             o.man_id = :man_id
        $extra_where
  </querytext>
</fullquery>

<fullquery name="objects_views2">
  <querytext>
        select v.views_count,v.unique_views,v.last_viewed,v.object_id,
               i.item_title as title
        from view_aggregates v,
             ims_cp_items i,
             ims_cp_organizations o
        where
             i.ims_item_id = v.object_id
        and
             i.org_id = o.org_id
	and
             o.man_id = :man_id
        $extra_where
  </querytext>
</fullquery>

</queryset>