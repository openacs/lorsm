<?xml version="1.0"?>
<queryset>

    <fullquery name="select_cl_source">
        <querytext>
            select '(' || source_l || ') ' || source_v as source
            from ims_md_classification_taxpath
            where ims_md_cl_ta_id = :ims_md_cl_ta_id
                and ims_md_cl_id = :ims_md_cl_id
        </querytext>
    </fullquery>

    <fullquery name="select_cl_taxon">
        <querytext>
            select identifier, '(' || entry_l || ') ' || entry_s as entry
            from ims_md_classification_taxpath_taxon
            where ims_md_cl_ta_id = :ims_md_cl_ta_id
        </querytext>
    </fullquery>

</queryset>
