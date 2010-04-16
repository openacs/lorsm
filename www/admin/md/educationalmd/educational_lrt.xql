<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_md_educational_lrt
            set lrt_s = :lrt_s,
                lrt_v = :lrt_v
            where ims_md_ed_lr_id = :ims_md_ed_lr_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_educational_lrt
                (ims_md_ed_lr_id, ims_md_id, lrt_s, lrt_v)
            values
                (:ims_md_ed_lr_id, :ims_md_id, :lrt_s, :lrt_v)
        </querytext>
    </fullquery>

    <fullquery name="select_ed_lrt">
        <querytext>
            select '(' || lrt_s || ') ' || lrt_v as lrt, ims_md_ed_lr_id, ims_md_id
            from ims_md_educational_lrt
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="educationalmd_ltr_ad_form">
        <querytext>
            select *
            from ims_md_educational_lrt
            where ims_md_ed_lr_id = :ims_md_ed_lr_id
                and ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
