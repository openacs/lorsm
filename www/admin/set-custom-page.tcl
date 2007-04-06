ad_page_contract {
    Set a start/end page from existing ims_cp_item
} {
    man_id
    type
    {return_url ""}
}

set label [_ "lorsm.Choose_${type}_page"]
set page_title $label
set context [list $page_title]

set options [lors::items_select_options -man_id $man_id]
set options [linsert $options 0 [list "-- Add New Page --" ""]]

ad_form -name set-page -export {man_id ims_item_id type} -form {
    {ims_item_id:text(select),optional {label $label} {options $options}}
} -on_submit {
    if {$ims_item_id eq ""} {
	ad_returnredirect [export_vars -base item-add-edit {man_id type}]
	ad_script_abort
    }
    set item_id [content::revision::item_id -revision_id $ims_item_id] 

    lorsm::set_custom_page \
	-man_id $man_id \
	-item_id $item_id \
	-type $type

    if {$return_url eq "" } {
	set return_url [export_vars -base course-structure {man_id}]
    }

    ad_returnredirect $return_url
    ad_script_abort
}