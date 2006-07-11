set man_id [ ad_get_client_property trackingrte man_id ]
set community_id [dotlrn_community::get_community_id]

template::list::create \
    -name students \
    -multirow students \
    -elements {
	course_name {
		label "Course title"
	}
	user_id {
		label "student ID"
            	display_eval {[person::name -person_id $user_id]}
		link_url_col drill_url 
	}
	max_attained {
		label "Max raw score attained by this student"
	}

    }

db_multirow \
    -extend {
	edit_url
	drill_url
    } students which_students {
  	select user_id, course_name,  max(score_raw) as max_attained from
		(
		select * 
		from 
			lorsm_student_track lorsm, lorsm_cmi_core cmi, ims_cp_manifests manif
		where 
			lorsm.community_id=:community_id
		and 
			lorsm.track_id=cmi.track_id
		and 
			lorsm.course_id=:man_id
		and 
			manif.man_id=:man_id
		) alltracks
		group by 
			user_id, course_name 
  } {
	set edit_url [export_vars -base "drill-student" {user_id}]
	set drill_url [export_vars -base "drill-student" {user_id}]
    }

