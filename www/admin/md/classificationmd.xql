<?xml version="1.0"?>
<queryset>

    <fullquery name="select_cl_class">
        <querytext>
            select purpose_s, purpose_v, ims_md_cl_id, ims_md_id
            from ims_md_classification
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
