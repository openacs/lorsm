<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="template_root">      
      <querytext>

      select content_template__get_root_folder()

      </querytext>
</fullquery>

<fullquery name="get_item_id">
      <querytext>
    select content_item__get_id(:url, :content_root, 'f') as item_id
      </querytext>
</fullquery>
 
<fullquery name="check_file_to_imsitem">
      <querytext>
 select i.ims_item_id as imsitem_id from ims_cp_items_to_resources i, ims_cp_files f where f.file_id=:file_id and i.res_id=f.res_id;
      </querytext>
</fullquery>


</queryset>
