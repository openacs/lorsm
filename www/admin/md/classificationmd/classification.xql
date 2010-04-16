<?xml version="1.0"?>
<queryset>

    <fullquery name="select_cl_pur">
        <querytext>
            select purpose_s, purpose_v
            from ims_md_classification
            where ims_md_cl_id = :ims_md_cl_id
        </querytext>
    </fullquery>

    <fullquery name="select_cl_tpath">
        <querytext>
            select '(' || ctp.source_l || ') ' || ctp.source_v as source,
                ctp.ims_md_cl_ta_id, ctp.ims_md_cl_id, cl.ims_md_id
            from ims_md_classification_taxpath ctp, ims_md_classification cl
            where ctp.ims_md_cl_id = :ims_md_cl_id
                and cl.ims_md_cl_id = :ims_md_cl_id
        </querytext>
    </fullquery>

    <fullquery name="select_cl_desc">
        <querytext>
            select '(' || descrip_l || ') ' || descrip_s as desc
            from ims_md_classification_descrip
            where ims_md_cl_id = :ims_md_cl_id
        </querytext>
    </fullquery>

    <fullquery name="select_cl_key">
        <querytext>
            select '(' || keyword_l || ') ' || keyword_s as keyword
            from ims_md_classification_keyword
            where ims_md_cl_id = :ims_md_cl_id
        </querytext>
    </fullquery>

</queryset>
