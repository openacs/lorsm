<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_md_classification_keyword
                set keyword_l = :keyword_l,
                    keyword_s = :keyword_s
            where ims_md_cl_ke_id = :ims_md_cl_ke_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_classification_keyword
                (ims_md_cl_ke_id, ims_md_cl_id, keyword_l, keyword_s)
            values
                (:ims_md_cl_ke_id, :ims_md_cl_id, :keyword_l, :keyword_s)
        </querytext>
    </fullquery>

    <fullquery name="classificationmd_key_ad_form">
        <querytext>
            select *
            from ims_md_classification_keyword
            where ims_md_cl_ke_id = :ims_md_cl_ke_id
                and ims_md_cl_id = :ims_md_cl_id
        </querytext>
    </fullquery>

    <fullquery name="select_cl_key">
        <querytext>
            select '[' || kw.keyword_l || '] ' || kw.keyword_s as keyword,
                kw.ims_md_cl_ke_id, cl.ims_md_cl_id, cl.ims_md_id
            from ims_md_classification_keyword kw, ims_md_classification cl
            where kw.ims_md_cl_id = cl.ims_md_cl_id
                and kw.ims_md_cl_id = :ims_md_cl_id
        </querytext>
    </fullquery>

</queryset>
