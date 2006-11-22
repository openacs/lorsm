<?xml version="1.0"?>
<queryset>

<fullquery name="lorsm::menu::leftnav.portal_page">
  <querytext>
	select page_id, sort_key
	from portal_pages
	where portal_id = :portal_id
	and pretty_name = :fs_link
  </querytext>
</fullquery>

<fullquery name="lorsm::menu::leftnav.update_portlet">
  <querytext>
      update portal_element_map
      set page_id = :page_id,
      state = 'full'
      where element_id = :element_id
  </querytext>
</fullquery>

<fullquery name="lorsm::menu::leftnav.mans">
  <querytext>
      select cp.man_id, cp.fs_package_id, cp.folder_id
      from ims_cp_manifests cp, -- acs_objects acs, ims_cp_manifest_class cpmc
      where cp.man_id = cpmc.man_id
      and cpmc.lorsm_instance_id = :package
      and cpmc.isenabled = 't'
      order by cp.man_id desc -- acs.creation_date desc
  </querytext>
</fullquery>

<fullquery name="lorsm::menu::leftnav.sql">
  <querytext>
      select i.ims_item_id as item_id, i.item_title as item_title
      from ims_cp_items i
      where i.org_id = :org_id
      and exists
      (select 1
      from acs_object_party_privilege_map p
      where p.object_id = i.ims_item_id 
      and p.party_id = :user_id
      and p.privilege = 'read')
      order by i.ims_item_id
  </querytext>
</fullquery>

<fullquery name="lorsm::menu::leftnav.select_folder_key">
  <querytext>
      select key 
      from fs_folders 
      where folder_id = :folder_id
  </querytext>
</fullquery>

<fullquery name="lorsm::menu::leftnav.href">
  <querytext>
      select href 
      from ims_cp_resources r, ims_cp_items_to_resources ir 
      where ir.ims_item_id = :item_id and ir.res_id = r.res_id
  </querytext>
</fullquery>

<fullquery name="lorsm::menu::leftnav.sql">
  <querytext>
  </querytext>
</fullquery>

</queryset>