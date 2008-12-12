<?xml version="1.0"?>
<queryset>

    <fullquery name="select_lang">
        <querytext>
            select ims_md_id
            from ims_md_metadata
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_metadata
            set language = :language
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_metadata
                (ims_md_id, language)
            values
                (:ims_md_id, :language)
        </querytext>
    </fullquery>

    <fullquery name="select_md_lang">
        <querytext>
            select language, ims_md_id
            from ims_md_metadata
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
