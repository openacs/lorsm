<?xml version="1.0"?>
<queryset>

    <fullquery name="select_students">
        <querytext>
            select user_id as student_name, start_time, end_time
            from lorsm_student_track
            where community_id = :community_id
                and course_id    = :man_id
                and end_time NOTNULL
            order by start_time desc
        </querytext>
    </fullquery>

    <fullquery name="objects_views">
        <querytext>
            select v.*, i.item_title as title
            from views_views v, ims_cp_items i, ims_cp_organizations o
            where i.ims_item_id = v.object_id
                and i.org_id = o.org_id
                and o.man_id = :man_id
            $extra_where
        </querytext>
    </fullquery>

    <fullquery name="objects_views2">
        <querytext>
            select v.*, i.item_title as title
            from view_aggregates v, ims_cp_items i, ims_cp_organizations o
            where i.ims_item_id = v.object_id
                and i.org_id = o.org_id
                and o.man_id = :man_id
            $extra_where
        </querytext>
    </fullquery>

    <fullquery name="select_students2">
        <querytext>
            select user_id as student_name, count(*) as counter,
                sum(end_time - start_time) as time_spent
            from lorsm_student_track
            where community_id = :community_id
                and course_id = :man_id
                and end_time NOTNULL
            group by user_id
        </querytext>
    </fullquery>

</queryset>
