<?xml version="1.0"?>
<queryset>

    <fullquery name="do_insert_relation">
        <querytext>
            insert into ims_md_relation
                (ims_md_re_id, ims_md_id)
            values
                (:ims_md_re_id, :ims_md_id)
        </querytext>
    </fullquery>

    <fullquery name="do_insert_resource">
        <querytext>
            insert into ims_md_relation_resource
                (ims_md_re_re_id, ims_md_re_id)
            values
                (nextval('ims_md_relation_resource_seq'), :ims_md_re_id)
        </querytext>
    </fullquery>

</queryset>
