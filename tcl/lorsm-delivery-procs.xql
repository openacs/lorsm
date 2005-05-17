<?xml version="1.0"?>
<queryset>

<fullquery name="lorsm::delivery::get_item_other_folder.get_folders">
  <querytext>
    select 
           folder_id 
    from 
           cr_folders 
    where 
           label = :folder_part
  </querytext>
</fullquery>

<fullquery name="lorsm::delivery::get_item_other_folder.get_parent_folder">
  <querytext>
    select 
           parent_id 
    from 
           cr_items 
    where 
           item_id = :folder
  </querytext>
</fullquery>

<fullquery name="lorsm::delivery::get_item_id.get_item_id">
  <querytext>
    select 
           item_id 
    from 
           cr_revisions 
    where
           revision_id = :revision_id
  </querytext>
</fullquery>

<fullquery name="lorsm::delivery::get_folder_id_from_man_id.manifest_info">      
  <querytext>
    select 
           folder_id 
    from 
           ims_cp_manifests 
    where 
           man_id = :man_id
  </querytext>
</fullquery>

<fullquery name="lorsm::delivery::get_folder_name.get_folder_name">      
  <querytext>
    select 
           name 
    from 
           cr_items 
    where 
           item_id = :folder_id 
  </querytext>
</fullquery>

<fullquery name="lorsm::delivery::get_item_id_from_name_parent.get_content_root">      
  <querytext>
    select 
           item_id 
    from 
           cr_items 
    where
           name = :name
           and parent_id = :parent_id
  </querytext>
</fullquery>

<fullquery name="lorsm::delivery::get_href.href">      
  <querytext>
    select 
           href 
    from 
           ims_cp_resources r, ims_cp_items_to_resources ir
    where 
           ir.ims_item_id = :ims_item_id 
           and ir.res_id = r.res_id
  </querytext>
</fullquery>

<fullquery name="lorsm::delivery::get_ims_item_title.get_item_title">      
  <querytext>
    select 
           item_title 
    from 
           ims_cp_items 
    where 
           ims_item_id = :ims_item_id
  </querytext>
</fullquery>

<fullquery name="lorsm::delivery::get_res_id.get_res_id">      
  <querytext>
    select 
           res_id 
    from 
           ims_cp_items_to_resources 
    where 
           ims_item_id = :ims_item_id
  </querytext>
</fullquery>

<fullquery name="lorsm::delivery::get_file_id.get_file_id">      
  <querytext>
    select 
           file_id 
    from 
           ims_cp_files 
    where 
           res_id = :res_id
  </querytext>
</fullquery>

<fullquery name="lorsm::delivery::get_file_id_from_ims_item_id.get_file">
  <querytext>
	select 
               revision_id 
        from 
               cr_revisions 
        where 
               item_id = :item_id and 
               revision_id in (
		              select 
                                     f.file_id
                              from   
                                     ims_cp_files f,
                                     ims_cp_resources r,
	                             ims_cp_items_to_resources ir
                              where 
                                     f.res_id = r.res_id and
                                     r.res_id = ir.res_id and
                                     ir.ims_item_id = :ims_item_id
                              )
  </querytext>
</fullquery>

</queryset>