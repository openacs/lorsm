ad_page_contract {
    Include a page from another package 
    wrapped in minimal template
} {
    __include:optional
}

if {![info exists __include] || $__include eq ""} {
    #don't' return anything
    ad_script_abort
}

ad_return_template