<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_md_educational_ieur
                set ieur_s = :ieur_s,
                    ieur_v = :ieur_v
            where ims_md_ed_ie_id = :ims_md_ed_ie_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_educational_ieur
                (ims_md_ed_ie_id, ims_md_id, ieur_s, ieur_v)
            values
                (:ims_md_ed_ie_id, :ims_md_id, :ieur_s, :ieur_v)
        </querytext>
    </fullquery>

    <fullquery name="select_ed_ieur">
        <querytext>
            select '(' || ieur_s || ') ' || ieur_v as ieur, ims_md_ed_ie_id, ims_md_id
            from ims_md_educational_ieur
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="educationalmd_ieur_ad_form">
        <querytext>
            select *
            from ims_md_educational_ieur
            where ims_md_ed_ie_id = :ims_md_ed_ie_id
                and ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
