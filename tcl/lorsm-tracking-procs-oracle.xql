<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="lorsm::track::new.track_st_new">      
      <querytext>
	begin
	:1 := 	lorsm_lorsm_student_track.new (
			p_user_id => :user_id,
			p_community_id => :community_id,
			p_course_id => :course_id
		);
	end;
      </querytext>
</fullquery>

<fullquery name="lorsm::track::exit.track_st_exit">      
      <querytext>
	begin
		:1 := lorsm_lorsm_student_track.exit (
			p_track_id => :track_id 
		      );
	end;
      </querytext>
</fullquery>

</queryset>
