<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_md_general_key
            set keyword_l = :keyword_l,
                keyword_s = :keyword_s
            where ims_md_ge_key_id = :ims_md_ge_key_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_general_key
                (ims_md_ge_key_id, ims_md_id, keyword_l, keyword_s)
            values
                (:ims_md_ge_key_id, :ims_md_id, :keyword_l, :keyword_s)
        </querytext>
    </fullquery>

    <fullquery name="select_ge_key">
        <querytext>
            select keyword_l, keyword_s, ims_md_ge_key_id, ims_md_id
            from ims_md_general_key
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="generalmd_key_ad_form">
        <querytext>
            select *
            from ims_md_general_key
            where ims_md_ge_key_id = :ims_md_ge_key_id
                and ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
