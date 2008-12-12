<?xml version="1.0"?>
<queryset>

    <fullquery name="relationmd_kind_ad_form">
        <querytext>
            select *
            from ims_md_relation
            where ims_md_re_id = :ims_md_re_id
                and ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_relation
            set kind_s = :kind_s,
                kind_v = :kind_v
            where ims_md_re_id = :ims_md_re_id
        </querytext>
    </fullquery>

    <fullquery name="select_re_kind">
        <querytext>
            select  re.kind_s, re.kind_v, re.ims_md_re_id, re.ims_md_id, rere.ims_md_re_re_id
            from ims_md_relation re, ims_md_relation_resource rere
            where re.ims_md_re_id = :ims_md_re_id
                and rere.ims_md_re_id = :ims_md_re_id
        </querytext>
    </fullquery>

</queryset>
