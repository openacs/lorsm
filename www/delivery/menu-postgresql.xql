<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="sql">
  <querytext>
        SELECT
         	i.parent_item,
 		i.ims_item_id,
                i.item_title as item_title
        FROM 
		acs_objects o, ims_cp_items i, cr_items cr
	WHERE 
		o.object_type = 'ims_item_object'
           AND
		i.org_id = :org_id
	   AND
		o.object_id = i.ims_item_id
	   $extra_query
           AND
                cr.item_id = ( select item_id from cr_revisions where revision_id = i.ims_item_id)
	   AND 
	   	EXISTS
		(select 1
		   from acs_object_party_privilege_map p
		  where p.object_id = i.ims_item_id 
		    and p.party_id = :user_id
		    and p.privilege = 'read')

        ORDER BY 
               i.sort_order, o.object_id, cr.tree_sortkey
  </querytext>
</fullquery>

<fullquery name="organizations">
  <querytext>
    select 
       org.org_id,
       org.org_title as org_title,
       org.hasmetadata,
       tree_level(o.tree_sortkey) as indent
    from
       ims_cp_organizations org, acs_objects o
    where
       org.org_id = o.object_id
     and
       man_id = :man_id
    order by
       org_id
  </querytext>
</fullquery>

</queryset>