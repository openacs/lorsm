# packages/lorsm/www/md/rightsmd/rights_caor.tcl

ad_page_contract {
    
    Add/Edit Rights MD Copyright or other Restrictions
    
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
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../rightsmd" ims_md_id] "Rights MD"] "Add/Edit Copyrights or other Restrictions"]
set title "Edit Rights MD Copyright or other Restrictions"


# Form

ad_form -name rightsmd_caor \
    -cancel_url ../rightsmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {caor_s:text,nospell
	{section "Add/Edit Rights MD Copyright or other Restrictions"}
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }

    {caor_v:text,nospell
        {html {size 10}}
	{help_text "Whether copyright or other restrictions apply"}
        {label "Copyright or other Restrictions:"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the Rights Copyright details already exist...

    if {[db_0or1row select_type {select ims_md_id from ims_md_rights where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_rights
            set caor_s = :caor_s, caor_v = :caor_v
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_rights (ims_md_id, caor_s, caor_v)
            values
            (:ims_md_id, :caor_s, :caor_v) "
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../rightsmd" {ims_md_id}]
        ad_script_abort
} 

# Rights Copyright or other Restrictions
template::list::create \
    -name d_ri_caor \
    -multirow d_ri_caor \
    -no_data "No Copyright or other Restrictions Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	caor {
            label "Copyright Info"
        }
    }

db_multirow d_ri_caor select_ri_caor {
    select 
        '[' || caor_s || '] ' || caor_v as caor,
        ims_md_id
    from 
           ims_md_rights
    where
           ims_md_id = :ims_md_id
} 
