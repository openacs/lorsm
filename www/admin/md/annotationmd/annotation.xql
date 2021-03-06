<?xml version="1.0"?>
<queryset>

    <fullquery name="select_an_ent">
        <querytext>
            select entity
            from ims_md_annotation
            where ims_md_an_id = :ims_md_an_id
        </querytext>
    </fullquery>

    <fullquery name="select_an_date">
        <querytext>
            select date, '(' || date_l || ') ' || date_s as datels
            from ims_md_annotation
            where ims_md_an_id = :ims_md_an_id
        </querytext>
    </fullquery>

    <fullquery name="select_an_desc">
        <querytext>
            select '(' || descrip_l || ') ' || descrip_s as desc
            from ims_md_annotation_descrip
            where ims_md_an_id = :ims_md_an_id
        </querytext>
    </fullquery>

</queryset>
