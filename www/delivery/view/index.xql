<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/lorsm/www/delivery/view/index.xql -->
<!-- @author Derick Leony (derickleony@galileo.edu) -->
<!-- @creation-date 2006-05-30 -->
<!-- @arch-tag: 182B16DC-9CFF-44F5-8558-5FEB29B253E8 -->
<!-- @cvs-id $Id$ -->

<queryset>

<fullquery name="manifest_info">
    <querytext>
      select fs_package_id, folder_id
      from ims_cp_manifests
      where man_id = :man_id
    </querytext>
</fullquery>

<fullquery name="check_file_to_imsitem">
      <querytext>
	select i.ims_item_id as imsitem_id 
	from ims_cp_items_to_resources i, ims_cp_files f 
	where f.file_id=:file_id and i.res_id=f.res_id;
      </querytext>
</fullquery>

</queryset>