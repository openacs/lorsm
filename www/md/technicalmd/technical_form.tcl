# packages/lorsm/www/md/technicalmd/technical_form.tcl

ad_page_contract {
    
    Add/Edit Technical MD Format
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_te_fo_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_te_fo_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../technicalmd" im\s_md_id] "Technical MD"] "Edit Format"]
    set title "Edit Technical MD Format"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../technicalmd" im\s_md_id] "Technical MD"] "Add Format"]
    set title "Add Technical MD Format"
}

# Form

ad_form -name technicalmd_form \
    -cancel_url ../technicalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_te_fo_id:key(ims_md_technical_format_seq)

    {format:text,nospell
	{section "Add/Edit Technical MD Format"}
        {html {size 30}}
	{help_text "Technical data type of the resource"}
        {label "Format:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}}
    
} -select_query  {select * from ims_md_technical_format where ims_md_te_fo_id = :ims_md_te_fo_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_technical_format
            set format = :format
            where ims_md_te_fo_id = :ims_md_te_fo_id "

} -new_data {
       db_dml do_insert "
            insert into ims_md_technical_format (ims_md_te_fo_id, ims_md_id, format)
            values
            (:ims_md_te_fo_id, :ims_md_id, :format)"

} -after_submit {
    ad_returnredirect [export_vars -base "../technicalmd" {ims_md_id}]
        ad_script_abort
} 

# Technical Format
template::list::create \
    -name d_te_form \
    -multirow d_te_form \
    -no_data "No Format Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        format {
            label "Format"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "technical_form" {ims_md_te_fo_id ims_md_id}] }
            link_html {title "Edit Record"}
            html { align center }
        }
    }

db_multirow d_te_form select_te_form {
    select format,
           ims_md_te_fo_id,
           ims_md_id
    from 
           ims_md_technical_format
    where
           ims_md_id = :ims_md_id
} 
