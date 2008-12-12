<?xml version="1.0"?>
<queryset>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md
                (ims_md_id, schema, schemaversion)
            values
                (:ims_md_id, :schema, :schemaversion)
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md
            set schema = :schema,
                schemaversion = :schemaversion
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="upd_manifest">
        <querytext>
            update ims_cp_manifests
            set hasmetadata = 't'
            where man_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="upd_item">
        <querytext>
            update ims_cp_items
            set hasmetadata = 't'
            where ims_item_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="upd_organization">
        <querytext>
            update ims_cp_organizations
            set hasmetadata = 't'
            where org_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="upd_resource">
        <querytext>
            update ims_cp_resources
            set hasmetadata = 't'
            where res_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="upd_file">
        <querytext>
            update ims_cp_files
            set hasmetadata = 't'
            where file_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="select_md_schema">
        <querytext>
            select schema, schemaversion
            from ims_md
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
