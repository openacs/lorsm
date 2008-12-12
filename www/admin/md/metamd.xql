<?xml version="1.0"?>
<queryset>

    <fullquery name="select_md_cata">
        <querytext>
            select catalog, '[' || entry_l || ']' || ' ' || entry_s as entry_ls
            from ims_md_metadata_cata
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_md_cont">
        <querytext>
            select mdc.role_v || ' ' || '[' || mdc.role_s || ']' as role,
                mdce.entity, mdc.cont_date,
                '[' || mdc.cont_date_l || ']' || ' ' || mdc.cont_date_s as cont_date_ls
            from ims_md_metadata_contrib mdc, ims_md_metadata_contrib_entity mdce
            where mdc.ims_md_md_cont_id = mdce.ims_md_md_cont_id
                and mdc.ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_md_scheme">
        <querytext>
            select scheme
            from ims_md_metadata_scheme
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_md_lang">
        <querytext>
            select language
            from ims_md_metadata
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
