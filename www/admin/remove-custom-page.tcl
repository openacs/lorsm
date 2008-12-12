ad_page_contract {
    Remove a custom page relationship
} {
    man_id
    type
    {return_url ""}
}

db_dml remove_page {}

if {$return_url eq ""} {
    set return_url [export_vars -base course-structure {man_id}]
}

ad_returnredirect $return_url
