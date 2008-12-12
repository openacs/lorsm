<?xml version="1.0"?>
<queryset>

    <fullquery name="technicalmd_form_ad_form">
        <querytext>
            select *
            from ims_md_technical_format
            where ims_md_te_fo_id = :ims_md_te_fo_id
                and ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_technical_format
            set format = :format
            where ims_md_te_fo_id = :ims_md_te_fo_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_technical_format
                (ims_md_te_fo_id, ims_md_id, format)
            values
                (:ims_md_te_fo_id, :ims_md_id, :format)
        </querytext>
    </fullquery>

    <fullquery name="select_te_form">
        <querytext>
            select format, ims_md_te_fo_id, ims_md_id
            from ims_md_technical_format
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
