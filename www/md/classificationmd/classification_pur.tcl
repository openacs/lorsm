# packages/lorsm/www/md/classificationmd/classification_pur.tcl

ad_page_contract {
    
    Add/Edit Classification MD Purpose
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_cl_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title

set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"] [list [export_vars -base "../classificationmd" ims_md_id] "Classification MD"] [list [export_vars -base "classification" {ims_md_id ims_md_cl_id}] "Classification Entry"] "Add/Edit Purpose"]
set title "Edit Classification MD Purpose"


# Form

ad_form -name classificationmd_pur \
    -cancel_url classification?ims_md_id=$ims_md_id&ims_md_cl_id=$ims_md_cl_id \
    -mode edit \
    -form {

    ims_md_cl_id:key(ims_md_classification_seq)

    {purpose_s:text,nospell
	{section "Add/Edit Classification MD Purpose"}
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }
    
    {purpose_v:text,nospell
        {html {size 20}}
	{help_text "Characteristics of the resource described by this classification entry"}
        {label "Purpose:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

} -select_query  {select * from ims_md_classification where ims_md_cl_id = :ims_md_cl_id

} -edit_data {
        db_dml do_update "
            update ims_md_classification
            set purpose_s = :purpose_s,
            purpose_v = :purpose_v
            where ims_md_cl_id = :ims_md_cl_id "

} -after_submit {
    ad_returnredirect [export_vars -base "classification" {ims_md_cl_id ims_md_id}]
        ad_script_abort
} 

# Classification Purpose
template::list::create \
    -name d_cl_pur \
    -multirow d_cl_pur \
    -no_data "No Purpose Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	purpose_s {
            label ""
        }
	purpose_v {
            label ""
        }
    }

db_multirow d_cl_pur select_cl_pur {
    select purpose_s,
           purpose_v,
           ims_md_cl_id,
           ims_md_id
    from 
           ims_md_classification
    where
           ims_md_cl_id = :ims_md_cl_id
} 
