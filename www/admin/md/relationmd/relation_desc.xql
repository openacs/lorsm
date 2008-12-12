<?xml version="1.0"?>
<queryset>

    <fullquery name="relationmd_desc_ad_form">
        <querytext>
            select *
            from ims_md_relation_resource
            where ims_md_re_re_id = :ims_md_re_re_id
                and ims_md_re_id = :ims_md_re_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_relation_resource
            set descrip_l = :descrip_l,
                descrip_s = :descrip_s
            where ims_md_re_re_id = :ims_md_re_re_id
        </querytext>
    </fullquery>

    <fullquery name="select_re_desc">
        <querytext>
            select  '[' || rere.descrip_l || ']' || ' ' || rere.descrip_s as descrip,
                rere.ims_md_re_re_id, re.ims_md_re_id, re.ims_md_id
            from ims_md_relation_resource rere, ims_md_relation re
            where rere.ims_md_re_id = :ims_md_re_id
                and re.ims_md_re_id = :ims_md_re_id
        </querytext>
    </fullquery>

</queryset>
