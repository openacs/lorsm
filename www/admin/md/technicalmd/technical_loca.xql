<?xml version="1.0"?>
<queryset>

    <fullquery name="technicalmd_loca_ad_form">
        <querytext>
            select *
            from ims_md_technical_location
            where ims_md_te_lo_id = :ims_md_te_lo_id
                and ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_technical_location
            set type = :type,
                location = :location
            where ims_md_te_lo_id = :ims_md_te_lo_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_technical_location
                (ims_md_te_lo_id, ims_md_id, type, location)
            values
                (:ims_md_te_lo_id, :ims_md_id, :type, :location)
        </querytext>
    </fullquery>

    <fullquery name="select_te_loca">
        <querytext>
            select type, location, ims_md_te_lo_id, ims_md_id
            from ims_md_technical_location
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
