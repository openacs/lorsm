<?xml version="1.0"?>
<queryset>

    <fullquery name="select_re_kind">
        <querytext>
            select kind_s, kind_v
            from ims_md_relation
            where ims_md_re_id = :ims_md_re_id
                and ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_re_ident">
        <querytext>
            select identifier
            from ims_md_relation_resource
            where ims_md_re_id = :ims_md_re_id
                and ims_md_re_re_id = :ims_md_re_re_id
        </querytext>
    </fullquery>

    <fullquery name="select_re_cata">
        <querytext>
            select catalog, entry_l, entry_s
            from ims_md_relation_resource_catalog
            where ims_md_re_re_id = :ims_md_re_re_id
        </querytext>
    </fullquery>

    <fullquery name="select_re_desc">
        <querytext>
            select '(' || descrip_l || ')' || ' ' || descrip_s as descrip
            from ims_md_relation_resource
            where ims_md_re_id = :ims_md_re_id
                and ims_md_re_re_id = :ims_md_re_re_id
        </querytext>
    </fullquery>

</queryset>
