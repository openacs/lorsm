<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_md_educational_descrip
                set descrip_l = :descrip_l,
                    descrip_s = :descrip_s
            where ims_md_ed_de_id = :ims_md_ed_de_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_educational_descrip
                (ims_md_ed_de_id, ims_md_id, descrip_l, descrip_s)
            values
                (:ims_md_ed_de_id, :ims_md_id, :descrip_l, :descrip_s)
        </querytext>
    </fullquery>

    <fullquery name="select_ed_desc">
        <querytext>
            select '(' || descrip_l || ') ' || descrip_s as desc, ims_md_ed_de_id, ims_md_id
            from ims_md_educational_descrip
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="educationalmd_desc_ad_form">
        <querytext>
            select *
            from ims_md_educational_descrip
            where ims_md_ed_de_id = :ims_md_ed_de_id
                and ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
