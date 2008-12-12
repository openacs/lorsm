<?xml version="1.0"?>
<queryset>

    <fullquery name="select_size">
        <querytext>
            select ims_md_id
            from ims_md_technical
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_technical
            set t_size = :t_size
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_technical
                (ims_md_id, t_size)
            values
                (:ims_md_id, :t_size)
        </querytext>
    </fullquery>

    <fullquery name="select_te_size">
        <querytext>
            select t_size || ' bytes' as t_size_bytes, ims_md_id
            from ims_md_technical
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
