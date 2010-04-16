<?xml version="1.0"?>
<queryset>

    <fullquery name="select_type">
        <querytext>
            select ims_md_id
            from ims_md_educational
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_educational
            set int_type_s = :int_type_s,
                int_type_v = :int_type_v
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_educational
                (ims_md_id, int_type_s, int_type_v)
            values
                (:ims_md_id, :int_type_s, :int_type_v)
        </querytext>
    </fullquery>

    <fullquery name="select_ed_intt">
        <querytext>
            select '(' || int_type_s || ') ' || int_type_v as intt, ims_md_id
            from ims_md_educational
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
