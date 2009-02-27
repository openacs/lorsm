<?xml version="1.0"?>
<queryset>

    <fullquery name="isanysuspendedsession">
        <querytext>
            select lorsm.track_id as track_id
            from lorsm_student_track lorsm, lorsm_cmi_core cmi
            where lorsm.user_id = $user_id
                and lorsm.community_id = $community_id
                and lorsm.course_id = $currentcourse
                and lorsm.track_id = cmi.track_id
                and cmi.man_id = $currentcourse
                and cmi.item_id = $currentpage
            order by lorsm.track_id desc
            limit 1
        </querytext>
    </fullquery>

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

    <fullquery name="lmsinitialize">
        <querytext>
            insert into lorsm_cmi_core
                (track_id,man_id,item_id,student_id,student_name,lesson_location,lesson_status,
                    launch_data, comments,comments_from_lms, session_time, total_time, time_stamp)
            values
                (:currenttrackid,:currentcourse,:currentpage,:username,:name,'','not attempted',
                   :datafromlms,'','',0,0,CURRENT_TIMESTAMP)
        </querytext>
    </fullquery>

    <fullquery name="lmsinitialize2">
        <querytext>
            insert into lorsm_cmi_student_data
                (track_id,student_id,max_time_allowed,time_limit_action,mastery_score)
            values
                (:currenttrackid,:username,:maxtimeallowed,:timelimitaction,:masteryscore)
        </querytext>
    </fullquery>

    <fullquery name="get_adlcp_student_data2">
        <querytext>
            select max_time_allowed ,time_limit_action ,mastery_score
            from lorsm_cmi_student_data
            where track_id=:currenttrackid
        </querytext>
    </fullquery>

</queryset>
