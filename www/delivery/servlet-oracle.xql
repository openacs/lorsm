<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="isanysuspendedsession">
  <querytext>
	select * from (        
		select lorsm.track_id as track_id 
		from lorsm_student_track lorsm, lorsm_cmi_core cmi
		where lorsm.user_id = $user_id
		and lorsm.community_id = $community_id
		and lorsm.course_id = $currentcourse
		and lorsm.track_id = cmi.track_id 
		and not (cmi.lesson_status = 'completed' or cmi.lesson_status = 'passed')
		and cmi.man_id = $currentcourse
		and cmi.item_id = $currentpage
		order by lorsm.track_id desc
	)
	where rownum = 1
  </querytext>
</fullquery>

<fullquery name="isanysuspendedsession2">
  <querytext>
	select * from (        
	      select lorsm.track_id as track_id 
	      from lorsm_student_track lorsm, lorsm_cmi_core cmi
	      where lorsm.user_id = $user_id
	      and lorsm.community_id = $community_id
	      and lorsm.course_id = $currentcourse
	      and lorsm.track_id = cmi.track_id
	      and not (cmi.lesson_status = 'completed' or cmi.lesson_status = 'passed')
	      and cmi.man_id = $currentcourse
	      and cmi.item_id = $currentpage
	      order by lorsm.track_id desc
	)
	where rownum = 1
  </querytext>
</fullquery>

</queryset>