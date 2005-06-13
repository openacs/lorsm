<?xml version="1.0"?>
<queryset>

<fullquery name="select_d_courses">
  <querytext>
	select 
	   cp.man_id,
           cp.course_name,
           cp.identifier,
           cp.version,
           cp.fs_package_id,
	   case when cp.fs_package_id is null then 't'
		else 'f'
	   end as lorsm_p,
           cp.folder_id,
	   acs.creation_user,
	   acs.creation_date,
	   pf.folder_name,
	   pf.format_name,
	   acs.context_id,
           cpmc.community_id,
           cpmc.lorsm_instance_id
	from
           ims_cp_manifests cp, 
	   acs_objects acs, 
           ims_cp_manifest_class cpmc, 
           lorsm_course_presentation_formats pf
	where 
           cp.man_id = acs.object_id
	and
           cp.man_id = cpmc.man_id
        and
           cpmc.lorsm_instance_id = :package
	$extra_query
	and
           cpmc.isenabled = 't'
	and
	   pf.format_id = cp.course_presentation_format
	order by acs.creation_date desc
  </querytext>
</fullquery>

<fullquery name="get_last_viewed">
  <querytext>
            select v.last_viewed
              from views v,
                   ims_cp_items i,
                   ims_cp_organizations o
             where v.viewer_id = :user_id
               and v.object_id = i.ims_item_id
               and i.org_id = o.org_id
               and o.man_id = :man_id
            order by v.last_viewed desc
            limit 1
  </querytext>
</fullquery>

<fullquery name="get_total_items">
  <querytext>
            select i.ims_item_id
              from ims_cp_items i,
                   ims_cp_organizations o
             where o.man_id = :man_id
               and i.org_id = o.org_id   
  </querytext>
</fullquery>

<fullquery name="get_viewed_items">
  <querytext>
            select v.object_id
              from views v
             where v.viewer_id = :user_id
               and v.object_id in ([join $all_items ,])
  </querytext>
</fullquery>

<fullquery name="get_item_id">
  <querytext>
	select 
		item_id 
	from 
		cr_revisions 
	where 
		revision_id = :man_id
  </querytext>
</fullquery>

</queryset>