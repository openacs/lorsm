<?xml version="1.0"?>
<queryset>

    <fullquery name="lorsm::track::new.track_st_new">
        <querytext>
            select lorsm_student_track__new (:user_id, :community_id, :course_id);
        </querytext>
    </fullquery>

    <fullquery name="lorsm::track::exit.track_st_exit">
        <querytext>
            select lorsm_student_track__exit (:track_id);
        </querytext>
    </fullquery>

    <fullquery name="lorsm::track::exit.get_track">
        <querytext>
            select *
            from lorsm_student_track
            where track_id=:track_id
        </querytext>
    </fullquery>

    <fullquery name="lorsm::track::get_track_id.get_track_id">
        <querytext>
            select track_id
            from lorsm_student_track
            where community_id=:community_id
                and user_id=:user_id
        </querytext>
    </fullquery>

    <fullquery name="lorsm::track::istrackable.trackable">
        <querytext>
            select istrackable
            from ims_cp_manifest_class
            where man_id = :course_id
                and lorsm_instance_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="lorsm::track::update_elapsed_seconds.select_last_item_viewed">
        <querytext>
            select to_char(v.last_viewed,'YYYY-MM-DD HH24:MI:SS') as last_viewed
            from views_views v, ims_cp_items i, ims_cp_organizations o, lorsm_student_track t
            where t.track_id = :track_id
                and v.viewer_id = t.user_id
                and v.object_id = i.ims_item_id
                and i.org_id = o.org_id
                and o.man_id = t.course_id
            order by v.last_viewed desc
            limit 1
        </querytext>
    </fullquery>

    <fullquery name="lorsm::track::update_elapsed_seconds.update_elapsed_seconds">
        <querytext>
            update lorsm_student_track
            set elapsed_seconds = coalesce(elapsed_seconds,0) + :elapsed_seconds
            where track_id = :track_id
        </querytext>
    </fullquery>

</queryset>
