<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_md_classification_taxpath
                set source_l = :source_l,
                    source_v = :source_v
            where ims_md_cl_ta_id = :ims_md_cl_ta_id
        </querytext>
    </fullquery>

    <fullquery name="select_cl_tsource">
        <querytext>
            select '[' || ctp.source_l || '] ' || ctp.source_v as source, ctp.ims_md_cl_ta_id,
                ctp.ims_md_cl_id, cl.ims_md_id
            from ims_md_classification_taxpath ctp, ims_md_classification cl
            where ctp.ims_md_cl_ta_id = :ims_md_cl_ta_id
                and cl.ims_md_cl_id = :ims_md_cl_id
        </querytext>
    </fullquery>

    <fullquery name="classificationmd_tsource_ad_form">
        <querytext>
            select *
            from ims_md_classification_taxpath
            where ims_md_cl_ta_id = :ims_md_cl_ta_id
                and ims_md_cl_id = :ims_md_cl_id
        </querytext>
    </fullquery>

</queryset>
