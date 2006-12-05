<?xml version="1.0"?>
<queryset>

<fullquery name="exists">
  <querytext>
	select man_id, lorsm_instance_id 
	from ims_cp_manifest_class 
	where man_id = :man_id
	and lorsm_instance_id = :package_id
	and community_id = :community_id
  </querytext>
</fullquery>

</queryset>