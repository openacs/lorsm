<?xml version="1.0"?>
<queryset>

<fullquery name="select_suborgs">
  <querytext>
	select o.object_id, i.item_id, i.item_title as item_title,
	  i.hasmetadata, i.item_id as identifierref, i.type,
	  i.org_id, m.fs_package_id, m.folder_id, m.course_name
	from acs_objects o, ims_cp_items i, ims_cp_manifests m
	where o.object_type = 'ims_item'
	and i.org_id = :org_id
	and o.object_id = i.item_id
	and m.man_id = :man_id
	order by object_id
  </querytext>
</fullquery>

</queryset>