# packages/lorsm/www/md/educationalmd/educational_desc.tcl

ad_page_contract {
    
    Add/Edit Educational MD Description
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ed_de_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ed_de_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" ims_md_id] "Educational MD"] "Edit Description"]
    set title "Edit Educational MD Description"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" ims_md_id] "Educational MD"] "Add Description"]
    set title "Add Educational MD Description"
}

# Form

ad_form -name educationalmd_desc \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ed_de_id:key(ims_md_educational_descrip_seq)

    {descrip_l:text,nospell
	{section "Add/Edit Educational MD Description"}
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }

    {descrip_s:text(textarea),nospell
        {html {rows 2 cols 50}}
	{help_text "How the learning object is to be used"}
        {label "Description:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_educational_descrip where ims_md_ed_de_id = :ims_md_ed_de_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_educational_descrip
            set descrip_l = :descrip_l,
            descrip_s = :descrip_s
            where ims_md_ed_de_id = :ims_md_ed_de_id "
} -new_data {
       db_dml do_insert "
            insert into ims_md_educational_descrip (ims_md_ed_de_id, ims_md_id, descrip_l, descrip_s) 
            values (:ims_md_ed_de_id, :ims_md_id, :descrip_l, :descrip_s)"
} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Description
template::list::create \
    -name d_ed_desc \
    -multirow d_ed_desc \
    -no_data "No Description Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	desc {
            label "Description"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "educational_desc" {ims_md_ed_de_id ims_md_id}] }
            link_html {title "Edit Record"}
            html { align center }
        }
    }

db_multirow d_ed_desc select_ed_desc {
    select 
        '[' || descrip_l || '] ' || descrip_s as desc,
        ims_md_ed_de_id,
        ims_md_id
    from 
           ims_md_educational_descrip
    where
           ims_md_id = :ims_md_id
} 
