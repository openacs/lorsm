<?xml version="1.0"?>
<queryset>

    <fullquery name="select_size">
        <querytext>
            select ims_md_id
            from ims_md_technical
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_technical
            set instl_rmrks_l = :instl_rmrks_l,
                instl_rmrks_s = :instl_rmrks_s
            where ims_md_id = :ims_md_id"
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_technical
                (ims_md_id, instl_rmrks_l, instl_rmrks_s)
            values
                (:ims_md_id, :instl_rmrks_l, :instl_rmrks_s)
        </querytext>
    </fullquery>

    <fullquery name="select_te_inst">
        <querytext>
            select '[' || instl_rmrks_l || ']' || ' ' || instl_rmrks_s as instl_rmrks, ims_md_id
            from ims_md_technical
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
