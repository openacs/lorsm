# packages/lorsm/www/md/classificationmd/classification_tsource.tcl

ad_page_contract {
    
    Add/Edit Classification MD Taxonomic Path Source
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_cl_id:integer
    ims_md_cl_ta_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title

set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"] [list [export_vars -base "../classificationmd" ims_md_id] "Classification MD"] [list [export_vars -base "classification" {ims_md_id ims_md_cl_id ims_md_cl_ta_id}] "Classification Entry"] [list [export_vars -base "classification_tpath" {ims_md_id ims_md_cl_id ims_md_cl_ta_id}] "Taxonomic Paths"] "Add/Edit Source"]

set title "Edit Classification MD Taxonomic Path Source"


# Form

ad_form -name classificationmd_tsource \
    -cancel_url classification_tpath?ims_md_id=$ims_md_id&ims_md_cl_id=$ims_md_cl_id&ims_md_cl_ta_id=$ims_md_cl_ta_id \
    -mode edit \
    -form {

    ims_md_cl_ta_id:key(ims_md_classification_taxpath_seq)

    {source_l:text,nospell
	{section "Add/Edit Classification MD Taxonomic Path Source"}
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }
    
    {source_v:text,nospell
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }
    
    {ims_md_cl_id:text(hidden) {value $ims_md_cl_id}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

} -select_query  {select * from ims_md_classification_taxpath where ims_md_cl_ta_id = :ims_md_cl_ta_id and ims_md_cl_id = :ims_md_cl_id

} -edit_data {
        db_dml do_update "
            update ims_md_classification_taxpath
            set source_l = :source_l,
            source_v = :source_v
            where ims_md_cl_ta_id = :ims_md_cl_ta_id"

} -after_submit {
    ad_returnredirect [export_vars -base "classification_tpath" {ims_md_cl_ta_id ims_md_cl_id ims_md_id}]
        ad_script_abort
} 

# Classification Taxonomic Path Source
template::list::create \
    -name d_cl_tsource \
    -multirow d_cl_tsource \
    -no_data "No Taxonomic Path Source Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	source {
            label ""
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "classification_tsource" {ims_md_cl_ta_id ims_md_cl_id ims_md_id}] }
            link_html {title "Edit Record"}
            html { align center }
        }
    }

db_multirow d_cl_tsource select_cl_tsource {
   select
    '[' || ctp.source_l || '] ' || ctp.source_v as source,
    ctp.ims_md_cl_ta_id,
    ctp.ims_md_cl_id,
    cl.ims_md_id
    from 
           ims_md_classification_taxpath ctp,
           ims_md_classification cl
    where
           ctp.ims_md_cl_ta_id = :ims_md_cl_ta_id
    and    cl.ims_md_cl_id = :ims_md_cl_id
} 
