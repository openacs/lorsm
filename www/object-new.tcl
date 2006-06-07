# packages/lorsm/www/add-new.tcl

ad_page_contract {
    
    add a new learning object
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2006-06-05
    @cvs-id $Id$
} {
    man_id:integer,notnull
    add_type
} -properties {
} -validate {
} -errors {
}


set page_title "Add New"
set context [list $page_title]
