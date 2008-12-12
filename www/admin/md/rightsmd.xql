<?xml version="1.0"?>
<queryset>

    <fullquery name="select_ri_cost">
        <querytext>
            select '[' || cost_s || '] ' || cost_v as cost
            from ims_md_rights
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_ri_caor">
        <querytext>
            select '[' || caor_s || '] ' || caor_v as caor
            from ims_md_rights
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_ri_desc">
        <querytext>
            select '[' || descrip_l || '] ' || descrip_s as desc
            from ims_md_rights
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
