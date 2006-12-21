<?xml version="1.0"?>
<queryset>

<fullquery name="check">
  <querytext>
	select man_id, community_id, lorsm_instance_id
	from ims_cp_manifest_class
	where man_id = :man_id
	  and community_id = :community_id
  </querytext>
</fullquery>

<fullquery name="manifest">
  <querytext>
	select cp.man_id, cp.course_name,
	cp.identifier, cp.version,
--	text 'Yes' as hello,
        case
            when hasmetadata = 't' then 'Yes'
            else 'No'
        end as man_metadata,
        case 
            when isscorm = 't' then 'Yes'
            else 'No'
        end as isscorm,
	cp.isshared,
	acs.creation_user,
	acs.creation_date,
	   acs.context_id
	from ims_cp_manifests cp, acs_objects acs
	where cp.man_id = acs.object_id
	and  cp.man_id = :man_id
	and  cp.parent_man_id = 0
  </querytext>
</fullquery>

<fullquery name="submans">
  <querytext>
	select count(*) as submanifests 
	from ims_cp_manifests 
	where man_id = :man_id
	and parent_man_id = :man_id
  </querytext>
</fullquery>

</queryset>