# packages/lorsm/www/md/technicalmd/technical_otr.tcl

ad_page_contract {
    
    Add/Edit Technical MD Other Platform Requirements
    
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
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../technicalmd" \\\i\m\\s_md_id] "Technical MD"] "Add/Edit Other Platform Requirements"]
set title "Add/Edit Technical MD Other Platform Requirements"

# Form

ad_form -name technicalmd_otr \
    -cancel_url ../technicalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {otr_plt_l:text,nospell
	{section "Add/Edit Technical MD Other Platform Requirements"}
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }

    {otr_plt_s:text(textarea),nospell
        {html {rows 5 cols 60}}
	{help_text "Information on other hardware and software requirements"}
        {label "Other Platform Requirements:"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the tech other platform req details already exist...

    if {[db_0or1row select_size {select ims_md_id from ims_md_technical where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_technical
            set otr_plt_l = :otr_plt_l,
            otr_plt_s = :otr_plt_s
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_technical (ims_md_id, otr_plt_l, otr_plt_s)
            values
            (:ims_md_id, :otr_plt_l, :otr_plt_s)"
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../technicalmd" {ims_md_id}]
        ad_script_abort
} 

# Technical Installation Remarks
template::list::create \
    -name d_te_otr \
    -multirow d_te_otr \
    -no_data "No Other Platform Requirements Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        otr_plt {
            label "Other Platform Req."
        }
    }

db_multirow d_te_otr select_te_otr {
    select 
        '[' || otr_plt_l || ']' || ' ' || otr_plt_s as otr_plt,
        ims_md_id
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
} 
