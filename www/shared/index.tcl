# packages/lorsm/www/shared/index.tcl

ad_page_contract {
    
    View shared courses
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-07-09
    @arch-tag: 6222c3f4-af54-44a3-a84e-de89740c9aaa
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}

set title "Shared Courses"
set context [list "Shared Courses"]

set community_id [dotlrn_community::get_community_id]

# Permissions
dotlrn::require_user_admin_community -user_id [ad_conn user_id] -community_id $community_id
