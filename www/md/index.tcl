ad_page_contract {
    Displays/Adds IMS Metadata 

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 19 January 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context
set context [list "IMS Metadata Editor"]
set title "IMS Metadata Editor"
set link [export_vars -base "md_upload" ims_md_id]

set write_p [permission::permission_p -party_id [ad_conn user_id] -object_id $ims_md_id -privilege write]

set read_p [permission::permission_p -party_id [ad_conn user_id] -object_id $ims_md_id -privilege read]
