<?xml version="1.0"?>
<queryset>

    <fullquery name="select_re_relat">
        <querytext>
            select re.kind_s, re.kind_v, re.ims_md_id,
                re.ims_md_re_id, rere.ims_md_re_re_id
            from ims_md_relation re, ims_md_relation_resource rere
            where re.ims_md_id = :ims_md_id
                and rere.ims_md_re_id = re.ims_md_re_id
        </querytext>
    </fullquery>

</queryset>
