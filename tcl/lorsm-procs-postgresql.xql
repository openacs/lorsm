<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="lorsm::get_content_value.gcv_get_revision_id">
        <querytext>
            select 1
        </querytext>
    </fullquery>

    <fullquery name="lorsm::get_content_value.gcv_get_previous_content">
        <querytext>
            select content
            from cr_revisions
            where revision_id = :revision_id
        </querytext>
    </fullquery>


    <fullquery name="lorsm::init.get_item_id">
        <querytext>
            select content_item__get_id(:url, :content_root, 'f') as item_id
        </querytext>
    </fullquery>

    <fullquery name="lorsm::init.get_item_type">
        <querytext>
            select content_type
            from cr_items
            where item_id=:item_id
        </querytext>
    </fullquery>

    <fullquery name="lorsm::init.get_template_info">
        <querytext>
            select item_id, content_type
            from cr_items
            where item_id = :item_id
          </querytext>
    </fullquery>

    <fullquery name="lorsm::init.get_template_url">
        <querytext>
            select
              content_item__get_live_revision(content_item__get_template(:item_id, :context)) as template_id,
              content_template__get_path(content_item__get_template(:item_id, :context),:template_root) as template_url
            from dual
        </querytext>
    </fullquery>

    <fullquery name="lorsm::init_all.get_template_url">
        <querytext>
            select content_template__get_path(content_item__get_template(:item_id, :context),:template_root) as template_url
            from dual
        </querytext>
    </fullquery>

</queryset>
