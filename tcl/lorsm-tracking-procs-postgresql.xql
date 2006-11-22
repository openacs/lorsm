<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="lorsm::track::new.track_st_new">      
      <querytext>
	select lorsm_student_track__new (
		:user_id,
		:community_id,
		:course_id
	)
      </querytext>
</fullquery>

<fullquery name="lorsm::track::exit.track_st_exit">      
      <querytext>
	select lorsm_student_track__exit (
		:track_id 
	)
      </querytext>
</fullquery>

</queryset>
