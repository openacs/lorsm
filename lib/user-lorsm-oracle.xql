<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
<fullquery name="query">
  <querytext>
	select * from (
		select cpr.man_id, cpr.res_id, 'delivery' as needscorte
		from ims_cp_resources cpr
		where cpr.man_id = :man_id
		order by cpr.scorm_type desc)
	where rownum = 1 

  </querytext>
</fullquery>

<fullquery name="get_last_viewed">
  <querytext>
	select * from (
            select v.last_viewed
              from views_views v,
                   ims_cp_items i,
                   ims_cp_organizations o
             where v.viewer_id = :user_id
               and v.object_id = i.ims_item_id
               and i.org_id = o.org_id
               and o.man_id = :man_id
            order by v.last_viewed desc)
	where rownum = 1

  </querytext>
</fullquery>

</queryset>