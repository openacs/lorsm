# packages/lorsm/www/md/rightsmd/rights_desc.tcl

ad_page_contract {
    
    Add/Edit Rights MD Description
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../rightsmd" ims_md_id] "Rights MD"] "Add/Edit Description"]
set title "Edit Rights MD Description"


# Form

ad_form -name rightsmd_desc \
    -cancel_url ../rightsmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {descrip_l:text,nospell
	{section "Add/Edit Rights MD Description"}
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }

    {descrip_s:text(textarea),nospell
        {html {rows 2 cols 50}}
	{help_text "Conditions of use for the resource"}
        {label "Description:"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the Rights Description details already exist...

    if {[db_0or1row select_type {select ims_md_id from ims_md_rights where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_rights
            set descrip_l = :descrip_l, descrip_s = :descrip_s
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_rights (ims_md_id, descrip_l, descrip_s)
            values
            (:ims_md_id, :descrip_l, :descrip_s) "
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../rightsmd" {ims_md_id}]
        ad_script_abort
} 

# Rights Description
template::list::create \
    -name d_ri_desc \
    -multirow d_ri_desc \
    -no_data "No Description Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	desc {
            label "Description"
        }
    }

db_multirow d_ri_desc select_ri_desc {
    select 
        '[' || descrip_l || '] ' || descrip_s as desc,
        ims_md_id
    from 
           ims_md_rights
    where
           ims_md_id = :ims_md_id
} 
