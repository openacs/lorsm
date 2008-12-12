<?xml version="1.0"?>
<queryset>

    <fullquery name="lorsm::delivery::scorm::check_parents.someinfo">
        <querytext>
            select parent_item as father, o.object_type as father_type
            from ims_cp_items i, ims_cp_manifest_class im, acs_objects o
            where ( o.object_type = 'ims_item_object' or
                    o.object_type= 'ims_organization_object' )
                and o.object_id = i.parent_item
                and i.ims_item_id=:ims_item_id
                and im.man_id= :currentcourse
                and im.isenabled='t'
                and im.community_id=:community_id
        </querytext>
    </fullquery>

    <fullquery name="lorsm::delivery::scorm::check_parents.isanorg">
        <querytext>
            select i.man_id as father, o.object_type as father_type
            from ims_cp_organizations i, ims_cp_manifest_class im, acs_objects o
                where o.object_id = i.man_id
                    and i.org_id=:ims_item_id
                    and im.man_id= i.man_id
                    and im.man_id= :currentcourse
                    and im.isenabled='t'
                    and im.community_id=:community_id
        </querytext>
    </fullquery>

    <fullquery name="lorsm::delivery::scorm::check_parents.hasmanincompletedchildren">
        <querytext>
            select *
            from (  select o.man_id, org_title as item_title, org_id as item_id
                    from ims_cp_organizations o, ims_cp_manifest_class im
                    where o.man_id=:currentcourse
                        and im.man_id=o.man_id
                        and im.community_id=:community_id) as allitems
            where item_id not in (  select cmi.item_id
                                    from lorsm_cmi_core cmi, lorsm_student_track track
                                    where cmi.man_id=:currentcourse
                                        and track.user_id=:user_id
                                        and cmi.track_id=track.track_id
                                        and track.community_id=:community_id
                                        and lesson_status in ( 'completed', 'passed' ))
            limit 1
        </querytext>
    </fullquery>

    <fullquery name="lorsm::delivery::scorm::check_parents.hasblockincompletedchildren">
        <querytext>
            select *
            from (  select o.man_id, item_title, ims_item_id as item_id
                    from ims_cp_items i, ims_cp_organizations o, ims_cp_manifest_class im
                    where i.org_id=o.org_id
                        and im.man_id=o.man_id
                        and o.man_id= :currentcourse
                        and im.community_id= :community_id
                        and i.parent_item= :father) as allitems
            where item_id not in (  select cmi.item_id
                                    from lorsm_cmi_core cmi, lorsm_student_track track
                                    where cmi.man_id=:currentcourse
                                        and track.user_id=:user_id
                                        and cmi.track_id=track.track_id
                                        and track.community_id=:community_id
                                        and lesson_status in ( 'completed', 'passed'  ))
            limit 1
        </querytext>
    </fullquery>

    <fullquery name="lorsm::delivery::scorm::check_parents.isanysuspendedsession">
        <querytext>
            select lorsm.track_id as block_track_id, lesson_status as lesson_status_old
            from lorsm_student_track lorsm, lorsm_cmi_core cmi
                where lorsm.user_id = $user_id
                    and lorsm.community_id = $community_id
                    and lorsm.course_id = $currentcourse
                    and lorsm.track_id = cmi.track_id
                    and cmi.man_id = $currentcourse
                    and cmi.item_id = $father
            order by lorsm.track_id desc
            limit 1
        </querytext>
    </fullquery>

    <fullquery name="lorsm::delivery::scorm::check_parents.lmsinitialize">
        <querytext>
            insert into lorsm_cmi_core
                (track_id,man_id,item_id,student_id,student_name,lesson_location, lesson_status, launch_data,
                    comments,comments_from_lms, session_time, total_time, time_stamp)
            values
                (:block_track_id,:currentcourse,:father,:username,:name,:currentcourse, :target_status,'',
                    '',:target_comment,0,0,CURRENT_TIMESTAMP)
        </querytext>
    </fullquery>

</queryset>
