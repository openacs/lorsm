<?xml version="1.0"?>
<queryset>

<fullquery name="istherealready">
  <querytext>
	select * 
	from lorsm_cmi_core 
	where track_id = :currenttrackid
  </querytext>
</fullquery>

<fullquery name="get_adlcp_student_data">
  <querytext>
      select datafromlms,maxtimeallowed,timelimitaction,masteryscore 
      from ims_cp_items 
      where ims_item_id=:currentpage
  </querytext>
</fullquery>

<fullquery name="lmsinitialize1">
  <querytext>
      insert into lorsm_cmi_core (
      track_id,man_id,item_id,student_id,student_name,lesson_location, lesson_status,launch_data, 
      comments,comments_from_lms, session_time, total_time, time_stamp
      ) values (
      :currenttrackid,:currentcourse,:currentpage,:username,:name,:currentcourse,'not attempted',
      :datafromlms,'','commenti da lors',0,0,CURRENT_TIMESTAMP
      )
  </querytext>
</fullquery>

<fullquery name="lmsinitialize2">
  <querytext>
      insert into lorsm_cmi_student_data (
      track_id,student_id,max_time_allowed,time_limit_action,mastery_score
      ) values(
      :currenttrackid,:username,:maxtimeallowed,:timelimitaction,:masteryscore
      )				
  </querytext>
</fullquery>

<fullquery name="get_adlcp_student_data2">
  <querytext>
      select max_time_allowed ,time_limit_action ,mastery_score 
      from lorsm_cmi_student_data
      where track_id=:currenttrackid
  </querytext>
</fullquery>

<fullquery name="">
  <querytext>
  </querytext>
</fullquery>

<fullquery name="">
  <querytext>
  </querytext>
</fullquery>


</queryset>