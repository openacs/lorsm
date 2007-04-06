# show plain LORS webcontent
set ims_item_id [ad_get_client_property lorsm ims_id]
set content [cr_write_content -string -revision_id $ims_item_id]