<?xml version="1.0"?>
<queryset>

    <fullquery name="thiscmitrack">
        <querytext>
            select *
            from lorsm_cmi_core
            where track_id=:track_id
        </querytext>
    </fullquery>

    <fullquery name="istherealready">
        <querytext>
            select min(lorsm.track_id) as mint from lorsm_cmi_core cmi, lorsm_student_track lorsm
            where lorsm.community_id=:community_id
                and lorsm.course_id=:man_id
                and user_id=:user_id
                and lorsm.track_id=cmi.track_id
                and lorsm.track_id>:track_id
        </querytext>
    </fullquery>

    <fullquery name="single_student_track">
        <querytext>
            select *
            from lorsm_student_track lorsm, ims_cp_manifests manif
            where lorsm.community_id=$community_id
                and lorsm.course_id=$man_id
                and (lorsm.track_id>=$track_id $querypart)
                and manif.man_id=$man_id
                and user_id=$user_id
            order by lorsm.track_id asc
        </querytext>
    </fullquery>

</queryset>
