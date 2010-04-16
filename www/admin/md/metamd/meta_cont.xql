<?xml version="1.0"?>
<queryset>

    <fullquery name="metamd_cont_ad_form">
        <querytext>
            select *
            from ims_md_metadata_contrib mdc, ims_md_metadata_contrib_entity mdce
            where mdc.ims_md_md_cont_id = :ims_md_md_cont_id
                and mdc.ims_md_id = :ims_md_id
                and mdce.ims_md_md_cont_id = :ims_md_md_cont_id
        </querytext>
    </fullquery>

    <fullquery name="update_mdc">
        <querytext>
            update ims_md_metadata_contrib
            set role_v = :role_v,
                role_s = :role_s,
                cont_date = :cont_date,
                cont_date_l = :cont_date_l,
                cont_date_s = :cont_date_s
            where ims_md_md_cont_id = :ims_md_md_cont_id
        </querytext>
    </fullquery>

    <fullquery name="update_mdce">
        <querytext>
            update ims_md_metadata_contrib_entity
            set entity = :entity
            where ims_md_md_cont_id = :ims_md_md_cont_id
        </querytext>
    </fullquery>

    <fullquery name="insert_mdc">
        <querytext>
            insert into ims_md_metadata_contrib
                (ims_md_md_cont_id, ims_md_id, role_s, role_v, cont_date, cont_date_l, cont_date_s)
            values
                (:ims_md_md_cont_id, :ims_md_id, :role_s, :role_v, :cont_date, :cont_date_l, :cont_date_s)
        </querytext>
    </fullquery>

    <fullquery name="insert_mdce">
        <querytext>
            insert into ims_md_metadata_contrib_entity
                (ims_md_md_cont_enti_id, ims_md_md_cont_id, entity)
            values
                (nextval('ims_md_metadata_contrib_entity_seq'), :ims_md_md_cont_id, :entity)
        </querytext>
    </fullquery>

    <fullquery name="select_md_cont">
        <querytext>
            select mdc.role_v || ' ' || '(' || mdc.role_s || ')' as role,
                mdce.entity, mdc.cont_date,
                '(' || mdc.cont_date_l || ')' || ' ' || mdc.cont_date_s as cont_date_ls,
                mdc.ims_md_md_cont_id, mdc.ims_md_id
            from ims_md_metadata_contrib mdc, ims_md_metadata_contrib_entity mdce
            where mdc.ims_md_md_cont_id = mdce.ims_md_md_cont_id
                and mdc.ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
