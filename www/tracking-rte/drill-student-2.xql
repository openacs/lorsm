<?xml version="1.0"?>
<queryset>

<fullquery name="student_activity">
  <querytext>
	select *
        from lorsm_student_track lorsm, lorsm_cmi_core cmi, ims_cp_manifests manif, ims_cp_items imsitems
	where lorsm.community_id=:community_id
	and lorsm.track_id=cmi.track_id and lorsm.course_id=:man_id
	and manif.man_id=:man_id and cmi.man_id=:man_id
	and cmi.item_id=:identifierref and user_id=:user_id
	and imsitems.item_id=cmi.item_id
	order by cmi.track_id asc
  </querytext>
</fullquery>

</queryset>