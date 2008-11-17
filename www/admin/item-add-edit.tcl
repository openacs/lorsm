ad_page_contract {
    Edit an ims_cp_item that is webcontent type
    item_id is a cr_items.item_id
} {
    item_id:optional
    man_id
    type:optional
    {return_url ""}
}

ad_form \
    -name item \
    -export {man_id type} \
    -form {
        item_id:key

        {title:text {label "[_ acs-content-repository.Title]"}}

        {content:richtext(richtext)
            {label "[_ acs-content-repository.Content]"}
            {html {cols 80 style {width: 100%}}}
        }

    } -edit_request {
        set content [template::util::richtext::create \
                        [cr_write_content -string -item_id $item_id] text/html]
        set title [db_string get_title ""]

    } -new_data {
        set content [template::util::richtext::get_property text $content]
        set org_id [db_string get_org_id ""]
        set item_folder_id [db_string get_folder_id ""]
        #    ad_return_complaint 1 "folder_id '${item_folder_id}'"
        # TODO i bet we can make a generic webcontent
        # a subset of lors::itemcp::item_add_from_object
        # and handle all adding of objects from anywhere
        # to a lors course, for now, this works, and is consistent
        # with generic ims_cp webcontent objects
        set ims_item_id [lors::imscp::item_add \
                            -org_id $org_id \
                            -item_id $item_id \
                            -itm_folder_id $item_folder_id \
                            -identifier $item_id \
                            -title $title \
                            -parent_item $org_id]
        db_dml set_sort_order ""

        set revision_id [content::item::get_live_revision -item_id $item_id]
        content::revision::update_content \
            -revision_id $revision_id \
            -item_id $item_id \
            -content $content \
            -mime_type text/html \
            -storage_type [db_string get_storage_type ""]

        set res_id [lors::imscp::resource_add \
                        -identifier $revision_id \
                        -man_id $man_id \
                        -res_folder_id $item_folder_id]

        lors::imscp::item_to_resource_add \
            -item_id $ims_item_id \
            -res_id $res_id


    } -edit_data {
        set content [template::util::richtext::get_property text $content]
        set ims_item_id [content::item::get_latest_revision -item_id $item_id]
        content::revision::update_content \
            -revision_id $ims_item_id \
            -item_id $item_id \
            -content $content \
            -mime_type text/html \
            -storage_type [db_string get_storage_type ""]
        db_dml set_title ""

    } -after_submit {
        if {[info exists type]} {
            lorsm::set_custom_page \
                -man_id $man_id \
                -item_id $item_id \
                -type $type
        }

        if {$return_url eq ""} {
            set return_url [export_vars -base course-structure {man_id}]
        }

        ad_returnredirect -message "" $return_url
    }

set page_title [_ lorsm.Add_Content]
set context [list $page_title]
