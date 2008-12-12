<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_md_metadata_cata
            set catalog = :catalog,
                entry_l = :entry_l,
                entry_s = :entry_s
            where ims_md_md_cata_id = :ims_md_md_cata_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_metadata_cata
                (ims_md_md_cata_id, ims_md_id, catalog, entry_l, entry_s)
            values
                (:ims_md_md_cata_id, :ims_md_id, :catalog, :entry_l, :entry_s)
        </querytext>
    </fullquery>

    <fullquery name="metamd_cata_ad_form">
        <querytext>
            select *
            from ims_md_metadata_cata
            where ims_md_md_cata_id = :ims_md_md_cata_id
                and ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_md_cata">
        <querytext>
            select catalog, '[' || entry_l || ']' || ' ' || entry_s as entry_ls,
                ims_md_md_cata_id, ims_md_id
            from ims_md_metadata_cata
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
