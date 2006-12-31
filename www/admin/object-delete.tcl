ad_page_contract {
    Delete a learning object 
} {
    item_id
    return_url
}

lors::imscp::item_delete -item_id $item_id

ad_returnredirect $return_url
