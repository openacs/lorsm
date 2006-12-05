<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
<fullquery name="select_students1">
  <querytext>
	select user_id as student_name,
	start_time, end_time
	from lorsm_student_track
	where community_id = :community_id
	and course_id    = :man_id
        and end_time is not null
	order by start_time desc
  </querytext>
</fullquery>

<fullquery name="select_students2">
  <querytext>
	select user_id as student_name,
	count(*) as counter, sum(end_time - start_time) as time_spent
	from lorsm_student_track
	where community_id = :community_id
	and course_id    = :man_id
	and end_time is not null
	group by user_id
  </querytext>
</fullquery>

</queryset>