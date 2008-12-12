<?xml version="1.0"?>
<queryset>

    <fullquery name="select_lc_version">
        <querytext>
            select ims_md_id
            from ims_md_life_cycle
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_life_cycle
            set version_l = :version_l,
                version_s = :version_s
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_life_cycle
                (ims_md_id, version_l, version_s)
            values
                (:ims_md_id, :version_l, :version_s)
        </querytext>
    </fullquery>

    <fullquery name="select_lf_ver">
        <querytext>
            select version_l, version_s, ims_md_id
            from ims_md_life_cycle
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
