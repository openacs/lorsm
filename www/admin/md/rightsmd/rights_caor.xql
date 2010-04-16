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
            set caor_s = :caor_s, caor_v = :caor_v
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_rights
                (ims_md_id, caor_s, caor_v)
            values
                (:ims_md_id, :caor_s, :caor_v)
        </querytext>
    </fullquery>

    <fullquery name="select_ri_caor">
        <querytext>
            select '(' || caor_s || ') ' || caor_v as caor, ims_md_id
            from ims_md_rights
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
