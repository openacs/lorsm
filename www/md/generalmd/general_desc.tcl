# packages/lorsm/www/md/generalmd/general_desc.tcl

ad_page_contract {
    
    Add/Edit General MD Description
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ge_desc_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ge_desc_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../generalmd" ims_md_id] "General MD"] "Edit Description"]
    set title "Edit General MD Description"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../generalmd" ims_md_id] "General MD"] "Add Description"]
    set title "Add General MD Description"
}

# Form

ad_form -name generalmd_desc \
    -cancel_url ../generalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ge_desc_id:key(ims_md_general_desc_seq)

    {descrip_l:text,nospell,optional
	{section "Add/Edit General MD Description"}
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }

    {descrip_s:text(textarea),nospell
        {html {rows 5 cols 50}}
	{help_text "Describes learning object's content"}
        {label "Description:"}
    }
    
    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_general_desc where ims_md_ge_desc_id = :ims_md_ge_desc_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_general_desc
            set descrip_l = :descrip_l, descrip_s = :descrip_s
            where ims_md_ge_desc_id = :ims_md_ge_desc_id "
} -new_data {
        db_dml do_insert "
            insert into ims_md_general_desc (ims_md_ge_desc_id, ims_md_id, descrip_l, descrip_s)
            values
            (:ims_md_ge_desc_id, :ims_md_id, :descrip_l, :descrip_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "../generalmd" {ims_md_id}]
        ad_script_abort
} 

# General Language
template::list::create \
    -name d_gen_desc \
    -multirow d_gen_desc \
    -no_data "No Description Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        descrip_l {
            label "Language"
        }
	descrip_s {
	    label "Description"
	}
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "general_desc" {ims_md_ge_desc_id ims_md_id}] }
            link_html {title "Edit Record "}
            html { align center }
        }
    }

db_multirow d_gen_desc select_ge_desc {
    select descrip_l,
           descrip_s,
           ims_md_ge_desc_id,
           ims_md_id
    from 
           ims_md_general_desc
    where
           ims_md_id = :ims_md_id
} 
