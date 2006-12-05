<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="organizations">
  <querytext>
	select org.org_id, org.org_title as org_title,
	org.hasmetadata, tree_level(o.tree_sortkey) as indent
	from ims_cp_organizations org, acs_objects o
	where org.org_id = o.object_id
	and man_id = :man_id
	order by org_id
  </querytext>
</fullquery>

<fullquery name="blah">
  <querytext>
      select o.object_id,
      repeat('&nbsp;', (tree_level(tree_sortkey) - :indent)* 3) as indent,
      i.ims_item_id as item_id, i.item_title as item_title,
      i.hasmetadata, i.org_id,
      case
          when i.isshared = 'f' then ('false') else 'true'
      end as isshared,
      case 
          when i.identifierref <> '' then (
		select res.href 
                from ims_cp_items_to_resources i2r, ims_cp_resources res 
                where i2r.res_id = res.res_id and i2r.ims_item_id = i.ims_item_id)
          else ''
      end as identifierref,
      case 
          when i.identifierref <> '' then (
		select res.type
                from ims_cp_items_to_resources i2r, ims_cp_resources res 
		where i2r.res_id = res.res_id and i2r.ims_item_id = i.ims_item_id)
         else ''
      end as type,
      m.fs_package_id, m.folder_id, m.course_name
      from acs_objects o, ims_cp_items i, ims_cp_manifests m
      where o.object_type = 'ims_item_object'
      and i.org_id = :org_id
      and o.object_id = i.ims_item_id
      and m.man_id = :man_id
      order by tree_sortkey, object_id
  </querytext>
</fullquery>

</queryset>