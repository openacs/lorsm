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
            set difficulty_s = :difficulty_s, difficulty_v = :difficulty_v
            where ims_md_id = :ims_md_id "
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_educational
                (ims_md_id, difficulty_s, difficulty_v)
            values
                (:ims_md_id, :difficulty_s, :difficulty_v)
        </querytext>
    </fullquery>

    <fullquery name="select_ed_dif">
        <querytext>
            select '(' || difficulty_s || ') ' || difficulty_v as diff, ims_md_id
            from ims_md_educational
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
