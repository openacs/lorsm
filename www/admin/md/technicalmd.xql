<?xml version="1.0"?>
<queryset>

    <fullquery name="select_te_form">
        <querytext>
            select format
            from ims_md_technical_format
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_te_size">
        <querytext>
            select t_size || ' bytes' as t_size_bytes
            from ims_md_technical
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_te_loca">
        <querytext>
            select type, location
            from ims_md_technical_location
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_te_req">
        <querytext>
            select '(' || type_s || ')' || ' ' || type_v as type,
                '(' || name_s || ')' || ' ' || name_v as name, min_version, max_version
            from ims_md_technical_requirement
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_te_inst">
        <querytext>
            select '(' || instl_rmrks_l || ')' || ' ' || instl_rmrks_s as instl_rmrks
            from ims_md_technical
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_te_otr">
        <querytext>
            select '(' || otr_plt_l || ')' || ' ' || otr_plt_s as otr_plt
            from ims_md_technical
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_te_dur">
        <querytext>
            select duration_l, duration_s, duration || 's' as duration_sec
            from ims_md_technical
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
