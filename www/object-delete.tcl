ad_page_contract {
    Delete a learning object 
} {
    item_id
    return_url
}

permission::require_permission \
    -object_id [ad_conn package_id] \
    -party_id [ad_conn user_id] \
    -privilege "admin"

lors::imscp::item_delete -item_id $item_id

ad_returnredirect $return_url