<?xml version="1.0"?>
<queryset>

    <fullquery name="select_lc_version">
        <querytext>
            select ims_md_id
            from ims_md_life_cycle
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            update ims_md_life_cycle
            set status_s = :status_s,
                status_v = :status_v
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_lf_stat">
        <querytext>
            select status_s, status_v, ims_md_id
            from ims_md_life_cycle
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
