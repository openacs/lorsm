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
            set otr_plt_l = :otr_plt_l,
                otr_plt_s = :otr_plt_s
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_technical
                (ims_md_id, otr_plt_l, otr_plt_s)
            values
                (:ims_md_id, :otr_plt_l, :otr_plt_s)
        </querytext>
    </fullquery>

    <fullquery name="select_te_otr">
        <querytext>
            select '[' || otr_plt_l || ']' || ' ' || otr_plt_s as otr_plt, ims_md_id
            from ims_md_technical
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
