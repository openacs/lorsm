<?xml version="1.0"?>
<queryset>

<fullquery name="get_org_id">
  <querytext>
	select 
		org_id 
	from 
		ims_cp_organizations 
	where 
		man_id = :man_id	
  </querytext>
</fullquery>

<fullquery name="get_fs_package_id">
  <querytext>
	select 
		fs_package_id 
	from 
		ims_cp_manifests 
	where 
		man_id = :man_id
  </querytext>
</fullquery>


</queryset>