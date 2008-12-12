<?xml version="1.0"?>
<queryset>

    <fullquery name="select_ge_titles">
        <querytext>
            select object_type
            from acs_objects
            where object_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_schema_details">
        <querytext>
            select ims_md_id, schema, schemaversion
            from ims_md
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
