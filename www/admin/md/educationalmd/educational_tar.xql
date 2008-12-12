<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_md_educational_tar
            set tar_l = :tar_l,
                tar_s = :tar_s
            where ims_md_ed_ta_id = :ims_md_ed_ta_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_educational_tar
                (ims_md_ed_ta_id, ims_md_id, tar_l, tar_s)
            values
                (:ims_md_ed_ta_id, :ims_md_id, :tar_l, :tar_s)
        </querytext>
    </fullquery>

    <fullquery name="educationalmd_tar_ad_form">
        <querytext>
            select *
            from ims_md_educational_tar
            where ims_md_ed_ta_id = :ims_md_ed_ta_id
                and ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_ed_tar">
        <querytext>
            select '[' || tar_l || '] ' || tar_s as tar, ims_md_ed_ta_id, ims_md_id
            from ims_md_educational_tar
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
