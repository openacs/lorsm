<?xml version="1.0"?>
<queryset>

    <fullquery name="relationmd_cata_ad_form">
        <querytext>
            select *
            from ims_md_relation_resource_catalog
            where ims_md_re_re_ca_id = :ims_md_re_re_ca_id
                and ims_md_re_re_id = :ims_md_re_re_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_relation_resource_catalog
            set catalog = :catalog,
                entry_l = :entry_l,
                entry_s = :entry_s
            where ims_md_re_re_ca_id = :ims_md_re_re_ca_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_relation_resource_catalog
                (ims_md_re_re_ca_id, ims_md_re_re_id, catalog, entry_l, entry_s)
            values
                (:ims_md_re_re_ca_id, :ims_md_re_re_id, :catalog, :entry_l, :entry_s)
        </querytext>
    </fullquery>

    <fullquery name="select_re_cata">
        <querytext>
            select reca.catalog, reca.entry_l, reca.entry_s, reca.ims_md_re_re_ca_id,
                reca.ims_md_re_re_id, re.ims_md_id, re.ims_md_re_id
            from ims_md_relation_resource_catalog reca, ims_md_relation re
            where reca.ims_md_re_re_id = :ims_md_re_re_id
                and re.ims_md_re_id = :ims_md_re_id
        </querytext>
    </fullquery>

</queryset>
