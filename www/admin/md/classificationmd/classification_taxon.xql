<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_md_classification_taxpath_taxon
                set identifier = :identifier,
                    entry_l = :entry_l,
                    entry_s = :entry_s
            where ims_md_cl_ta_ta_id = :ims_md_cl_ta_ta_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_classification_taxpath_taxon
                (ims_md_cl_ta_ta_id, ims_md_cl_ta_id, identifier, entry_l, entry_s)
            values
                (:ims_md_cl_ta_ta_id, :ims_md_cl_ta_id, :identifier, :entry_l, :entry_s)
        </querytext>
    </fullquery>

    <fullquery name="select_cl_taxon">
        <querytext>
            select ctt.identifier, '(' || ctt.entry_l || ') ' || ctt.entry_s as entry,
                ctt.ims_md_cl_ta_id, ctt.ims_md_cl_ta_ta_id, cl.ims_md_cl_id, cl.ims_md_id
            from ims_md_classification_taxpath_taxon ctt, ims_md_classification cl
            where ctt.ims_md_cl_ta_id = :ims_md_cl_ta_id
                and cl.ims_md_cl_id = :ims_md_cl_id
        </querytext>
    </fullquery>

    <fullquery name="classificationmd_taxon_ad_form">
        <querytext>
            select *
            from ims_md_classification_taxpath_taxon
            where ims_md_cl_ta_ta_id = :ims_md_cl_ta_ta_id
                and ims_md_cl_ta_id = :ims_md_cl_ta_id
        </querytext>
    </fullquery>

</queryset>
