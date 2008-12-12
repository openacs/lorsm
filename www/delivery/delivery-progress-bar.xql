<?xml version="1.0"?>
<queryset>

    <fullquery name="get_last_viewed">
        <querytext>
            select object_id
            from views_views, lorsm_student_track
            where viewer_id = :user_id
                and object_id in ([template::util::tcl_to_sql_list $item_list])
                and track_id=:track_id
                and last_viewed > start_time
            order by last_viewed desc
            limit 1
        </querytext>
    </fullquery>

    <fullquery name="get_title">
        <querytext>
            select item_title
            from ims_cp_items
            where ims_item_id=:item_id
        </querytext>
    </fullquery>

    <fullquery name="get_title_prev">
        <querytext>
            select item_title
            from ims_cp_items
            where ims_item_id=:prev_item_id
        </querytext>
    </fullquery>

    <fullquery name="get_title_next">
        <querytext>
            select item_title
            from ims_cp_items
            where ims_item_id=:next_item_id
        </querytext>
    </fullquery>

    <fullquery name="get_title_current">
        <querytext>
            select item_title
            from ims_cp_items
            where ims_item_id=:item_id
        </querytext>
    </fullquery>

</queryset>
