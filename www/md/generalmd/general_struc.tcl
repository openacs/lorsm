# packages/lorsm/www/md/generalmd/general_struc.tcl

ad_page_contract {
    
    Add/Edit General MD Structure
    
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

set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../generalmd" im\\\\s_md_id] "General MD"] "Edit Structure"]
set title "Edit General MD Structure"

# Form

ad_form -name generalmd_struc \
    -cancel_url [export_vars -base "../generalmd" ims_md_id] \
    -mode edit \
    -form {

    {structure_v:text
	{section "Add/Edit General MD Structure"}
        {html {size 10}}
	{help_text "Organizational structure of the resource"}
        {label "Structure:"}
    }
    
    {structure_s:text,nospell,optional
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the structure details already exist...

    if {[db_0or1row select_structure {select ims_md_id from ims_md_general where ims_md_id = :ims_md_id}]} {

	db_dml do_update "
            update ims_md_general
            set structure_v = :structure_v, structure_s = :structure_s
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_general (ims_md_id, structure_v, structure_s)
            values
            (:ims_md_id, :structure_v, :structure_s)"

    }

} -after_submit {
    ad_returnredirect [export_vars -base "../generalmd" {ims_md_id}]
        ad_script_abort
} 

# General Structure
template::list::create \
    -name d_gen_struc \
    -multirow d_gen_struc \
    -no_data "No Structure Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        structure_s {
            label "Source"
	    html {align center}
        }
        structure_v {
            label "Value"
	    html {align center}
        }
    }

db_multirow d_gen_struc select_ge_struc {
    select structure_s,
           structure_v, 
           ims_md_id
    from 
           ims_md_general
    where
           ims_md_id = :ims_md_id
}

