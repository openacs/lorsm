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

set title "[_ lorsm.Shared_Courses]"
set context [list "[_ lorsm.Shared_Courses]"]

set community_id [dotlrn_community::get_community_id]

