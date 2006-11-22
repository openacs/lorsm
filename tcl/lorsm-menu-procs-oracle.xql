<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
<fullquery name="lorsm::menu::leftnav.folder">
  <querytext>
	select m.element_id, value as folder_id, p.page_id as current_page_id
	from portal_element_parameters ep,
	portal_element_map m,
	portal_pages p
	where ep.element_id = m.element_id
	and m.page_id = p.page_id
	and p.portal_id = :portal_id
	and ep.key = 'folder_id'
	and m.pretty_name = :fs_link
	and rownum = 1
  </querytext>
</fullquery>

<fullquery name="lorsm::menu::leftnav.organizations">
  <querytext>
	select org.org_id, org.org_title as org_title, org.hasmetadata, 
		(select level 
		from cr_items
		connect by prior item_id = parent_id
		start with item_id = (select item_id from cr_revisions where revision_id = org.org_id)) as indent
	from ims_cp_organizations org
	and man_id = :man_id
	order by org_id
  </querytext>
</fullquery>

</queryset>