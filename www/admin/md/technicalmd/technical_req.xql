<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_md_technical_requirement
            set type_v = :type_v,
                type_s = :type_s,
                name_v = :name_v,
                name_s = :type_s,
                min_version = :min_version,
                max_version = :max_version
            where ims_md_te_rq_id = :ims_md_te_rq_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_technical_requirement
                (ims_md_te_rq_id, ims_md_id, type_s, type_v, name_s, name_v, min_version, max_version)
            values
                (:ims_md_te_rq_id, :ims_md_id, :type_s, :type_v, :type_s, :name_v, :min_version, :max_version)
        </querytext>
    </fullquery>

    <fullquery name="select_te_req">
        <querytext>
            select  '[' || type_s || ']' || ' ' || type_v as type,
                '[' || name_s || ']' || ' ' || name_v as name,
                min_version, max_version, ims_md_te_rq_id, ims_md_id
            from ims_md_technical_requirement
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="technicalmd_req_ad_form">
        <querytext>
            select *
            from ims_md_technical_requirement
            where ims_md_te_rq_id = :ims_md_te_rq_id
                and ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
