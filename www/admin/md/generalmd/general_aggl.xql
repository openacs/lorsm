<?xml version="1.0"?>
<queryset>

    <fullquery name="select_aggregation_level">
        <querytext>
            select ims_md_id
            from ims_md_general
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_general
            set agg_level_v = :agg_level_v,
                agg_level_s = :agg_level_s
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_general
                (ims_md_id, agg_level_v, agg_level_s)
            values
                (:ims_md_id, :agg_level_v, :agg_level_s)
        </querytext>
    </fullquery>

    <fullquery name="select_ge_aggl">
        <querytext>
            select agg_level_s, agg_level_v, ims_md_id
            from ims_md_general
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="">
        <querytext>
        </querytext>
    </fullquery>

    <fullquery name="">
        <querytext>
        </querytext>
    </fullquery>

    <fullquery name="">
        <querytext>
        </querytext>
    </fullquery>

    <fullquery name="">
        <querytext>
        </querytext>
    </fullquery>

    <fullquery name="">
        <querytext>
        </querytext>
    </fullquery>

</queryset>
