<?xml version="1.0"?>
<queryset>

    <fullquery name="which_students">
        <querytext>
            select user_id, course_name,  max(score_raw) as max_attained
            from ( select *
                from lorsm_student_track lorsm, lorsm_cmi_core cmi, ims_cp_manifests manif
                where lorsm.community_id=:community_id
                    and lorsm.track_id=cmi.track_id
                    and lorsm.course_id=:man_id
                    and manif.man_id=:man_id) alltracks
            group by user_id, course_name
        </querytext>
    </fullquery>

</queryset>
