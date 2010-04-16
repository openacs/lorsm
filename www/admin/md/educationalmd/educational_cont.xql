<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_md_educational_context
                set context_s = :context_s,
                    context_v = :context_v
            where ims_md_ed_co_id = :ims_md_ed_co_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_educational_context
                (ims_md_ed_co_id, ims_md_id, context_s, context_v)
            values
                (:ims_md_ed_co_id, :ims_md_id, :context_s, :context_v)
        </querytext>
    </fullquery>

    <fullquery name="select_ed_cont">
        <querytext>
            select '(' || context_s || ') ' || context_v as context, ims_md_ed_co_id, ims_md_id
            from ims_md_educational_context
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="educationalmd_cont_ad_form">
        <querytext>
            select *
            from ims_md_educational_context
            where ims_md_ed_co_id = :ims_md_ed_co_id
                and ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
