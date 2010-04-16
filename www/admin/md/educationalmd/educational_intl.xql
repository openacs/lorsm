<?xml version="1.0"?>
<queryset>

    <fullquery name="select_size">
        <querytext>
            select ims_md_id
            from ims_md_educational
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_educational
            set int_level_s = :int_level_s,
                int_level_v = :int_level_v
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_educational
                (ims_md_id, int_level_s, int_level_v)
            values
                (:ims_md_id, :int_level_s, :int_level_v)
        </querytext>
    </fullquery>

    <fullquery name="select_ed_intl">
        <querytext>
            select '(' || int_level_s || ') ' || int_level_v as intl, ims_md_id
            from ims_md_educational
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
