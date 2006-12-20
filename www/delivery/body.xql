<?xml version="1.0"?>
<queryset>

<fullquery name="get_total_items">
  <querytext>
      select i.ims_item_id
      from ims_cp_items i, ims_cp_organizations o
      where o.man_id = :man_id
      and i.org_id = o.org_id 
  </querytext>
</fullquery>

<fullquery name="get_viewed_items">
  <querytext>
      select v.object_id
      from views_views v
      where v.viewer_id = :user_id
      and v.object_id in ([join $all_items ,])
  </querytext>
</fullquery>

<fullquery name="select_viewed_times">
  <querytext>
      select count(*) 
      from lorsm_student_track 
      where community_id = :community_id
      and course_id = :man_id
      and user_id = :user_id
  </querytext>
</fullquery>

<fullquery name="manifest">
  <querytext>
      select cp.course_name, cp.fs_package_id
      from ims_cp_manifests cp
      where cp.man_id = :man_id and  cp.parent_man_id = 0
  </querytext>
</fullquery>

</queryset>