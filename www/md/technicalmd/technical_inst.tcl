# packages/lorsm/www/md/technicalmd/technical_inst.tcl

ad_page_contract {
    
    Add/Edit Technical MD Installation Remarks
    
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
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../technicalmd" \\\im\\s_md_id] "Technical MD"] "Edit Installation Remarks"]
set title "Add/Edit Technical MD Installation Remarks"

# Form

ad_form -name technicalmd_inst \
    -cancel_url ../technicalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {instl_rmrks_l:text,nospell
	{section "Add/Edit Technical MD Installation Remarks"}
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }

    {instl_rmrks_s:text(textarea),nospell
        {html {rows 5 cols 60}}
	{help_text "Information on how to install the resource"}
        {label "Installation Remarks:"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}    

} -on_submit {
    # check if the tech size details already exist...

    if {[db_0or1row select_size {select ims_md_id from ims_md_technical where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_technical
            set instl_rmrks_l = :instl_rmrks_l,
            instl_rmrks_s = :instl_rmrks_s
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_technical (ims_md_id, instl_rmrks_l, instl_rmrks_s)
            values
            (:ims_md_id, :instl_rmrks_l, :instl_rmrks_s) "
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../technicalmd" {ims_md_id}]
        ad_script_abort
} 

# Technical Installation Remarks
template::list::create \
    -name d_te_inst \
    -multirow d_te_inst \
    -no_data "No Installation Remarks Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        instl_rmrks {
            label "Installation Remarks"
        }
    }

db_multirow d_te_inst select_te_inst {
    select 
        '[' || instl_rmrks_l || ']' || ' ' || instl_rmrks_s as instl_rmrks,
        ims_md_id
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
} 
