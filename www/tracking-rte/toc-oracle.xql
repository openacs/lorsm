<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="organizations">
  <querytext>
       	select org.org_id, org.org_title as org_title, org.hasmetadata,
        	(select level
	        from acs_objects
	        connect by prior object_id = context_id
	        start with object_id = org.org_id) as indent
	from ims_cp_organizations org
	where man_id = :man_id
	order by org_id
  </querytext>
</fullquery>

<fullquery name="organization_item">
  <querytext>
	select i.ims_item_id as object_id,
		((select level
	                from acs_objects connect by prior object_id = context_id
        	        start with object_id = i.org_id) - :indent
	                ) * 2 as indent,
	                i.ims_item_id, i.item_title as item_title,
	                i.hasmetadata, i.ims_item_id as identifierref,
		        i.type, i.org_id, m.fs_package_id,
		        m.folder_id, m.course_name
        from ims_cp_items i, ims_cp_manifests m
        where i.org_id = :org_id and m.man_id = :man_id
        order by indent, ims_item_id;
  </querytext>
</fullquery>

</queryset>