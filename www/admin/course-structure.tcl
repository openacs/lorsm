# # packages/lorsm/www/course_structure.tcl

 ad_page_contract {

     View Manifest Course Structure

     @author Ernie Ghiglione (ErnieG@mm.st)
     @creation-date 2004-03-31
     @arch-tag 208f2801-d110-45d3-9401-d5eae1f72c93
     @cvs-id  $Id$
} {
    man_id:integer,notnull
} -properties {
} -validate {
} -errors {
}

set context [list "[_ lorsm.Course_Structure]"]
set title "[_ lorsm.Course_Structure]"

set custom_page_types [list start end]
array set custom_page_pretty_names [list \
                                        start "[_ lorsm.Start_Page]" \
                                        end "[_ lorsm.End_Page]"]

array set custom_page_order [list start 0 end 1]

set lorsm_custom_page_ids [list]
set existing_custom_page_types [list]
db_multirow -extend {order pretty_name} custom_pages get_custom_pages {} {
    lappend lorsm_custom_page_ids $ims_item_id
    lappend existing_custom_page_types $type
    set order $custom_page_order($type)
    set pretty_name $custom_page_pretty_names($type)
}

foreach type $custom_page_types {
    if {[lsearch $existing_custom_page_types $type] <0} {
        template::multirow append custom_pages \
            "" \
            "" \
            $type \
            "" \
            $custom_page_order($type) \
            $custom_page_pretty_names($type)
    }
}
template::multirow sort custom_pages order

set extra_admin_html [template::adp_include /packages/lorsm/lib/custom-page-admin \
    [list &custom_pages custom_pages man_id $man_id]]
