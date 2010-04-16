<?xml version="1.0"?>
<queryset>

    <fullquery name="select_type">
        <querytext>
            select ims_md_id
            from ims_md_rights
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_rights
            set descrip_l = :descrip_l,
                descrip_s = :descrip_s
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_rights
                (ims_md_id, descrip_l, descrip_s)
            values
                (:ims_md_id, :descrip_l, :descrip_s) "
        </querytext>
    </fullquery>

    <fullquery name="select_ri_desc">
        <querytext>
            select '(' || descrip_l || ') ' || descrip_s as desc, ims_md_id
            from ims_md_rights
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
