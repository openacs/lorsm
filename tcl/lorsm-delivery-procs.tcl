# packages/lorsm/tcl/lorsm-delivery-procs.tcl
ad_library {
    LORS Management Procedures for delivery pages

    @author Miguel Mairn (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net
}

namespace eval lorsm::delivery {}

ad_proc -private lorsm::delivery::get_item_other_folder {
    -url:required
} {
    Check if the item exists in other folders using the url, returns the item_id or "" fro the especific url
    @url@ url of the file to check of format folder_name/filename.extension where multiple folders can be add
} {
    set item_id ""
    set folder_part [lindex [split $url "/"] 0]

    # We get a list of all folders that have name equal to folder_part
    set content_folders [db_list_of_lists get_folders { }]

    # Foreach folder that has that name we are going to check for the file name inside
    foreach folder $content_folders {
        set parent_folder [db_string get_parent_folder { } -default ""]
        set aux [content::item::get_id -item_path $url \
                    -root_folder_id $parent_folder \
                    -resolve_index "f"]
        if { ![empty_string_p $aux] } {
            # This is a match
            set item_id $aux
        }
    }
    return $item_id
}


ad_proc -private lorsm::delivery::get_item_id {
    -revision_id:required
} {
    Return the item_id for the especific revision_id
} {
    return [db_string get_item_id { }]
}


ad_proc -private lorsm::delivery::get_folder_id_from_man_id {
    -man_id:required
} {
    Return the folder_id for the especific man_id
} {
    return [db_string manifest_info { } -default ""]
}


ad_proc -private lorsm::delivery::get_folder_name {
    -folder_id:required
} {
    Returns the folder name for an especific folder_id
} {
    return [db_string get_folder_name { } -default ""]
}


ad_proc -private lorsm::delivery::get_item_id_from_name_parent {
    -parent_id:required
    -name:required
} {
    Return the item_id using parent_id and the item name
} {
    return [db_string get_content_root { } -default ""]
}


ad_proc -private lorsm::delivery::get_href {
    -ims_item_id:required
} {
    Return the href on ims_cp_resources for an especific ims_item_id
} {
    return [db_string href { } -default ""]
}


ad_proc -private lorsm::delivery::get_ims_item_title {
    -ims_item_id:required
} {
    Returns the item_title stored ons ims_cp_items table for an especific ims_item_id
} {
    return [db_string get_item_title { } -default ""]
}


ad_proc -private lorsm::delivery::get_res_id {
    -ims_item_id:required
} {
    Returns the associated resource id (res_id) for one ims_item_id
} {
    return [db_string get_res_id { } -default ""]
}


ad_proc -private lorsm::delivery::get_file_id {
    -res_id:required
} {
    Returns the associated file_id to one resource (res_id)
} {
    return [db_string get_file_id { } -default ""]
}


ad_proc -private lorsm::delivery::get_file_id_from_ims_item_id {
    -ims_item_id:required
    -item_id:required
} {
    Returns the file associated to @item_id@ and @ims_item_id@, returns empty string if nothing found

    @ims_item_id@  The ims_item_id that is associated to this file (This is the one coming from the
                   menu on delivery pages )
    @item_id@      The item_id that has all revisions of one file ( This is fetch from the url and content
                   root variables )
    returns        file_id or empty string
} {
    return [db_string get_file { } -default ""]
}
