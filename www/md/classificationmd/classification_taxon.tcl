# packages/lorsm/www/md/classificationmd/classification_taxon.tcl

ad_page_contract {
    
    Add/Edit Classification MD Taxonomic Path Taxonomy
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_cl_id:integer
    ims_md_cl_ta_id:integer
    ims_md_cl_ta_ta_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_cl_ta_ta_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"] [list [export_vars -base "../classificationmd" ims_md_id] "Classification MD"] [list [export_vars -base "classification" {ims_md_id ims_md_cl_id ims_md_cl_ta_id}] "Classification Entry"] [list [export_vars -base "classification_tpath" {ims_md_id ims_md_cl_id ims_md_cl_ta_id}] "Taxonomic Paths"] "Edit Taxonomy"]
    set title "Edit Classification MD Taxonomic Path Taxonomy"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"] [list [export_vars -base "../classificationmd" ims_md_id] "Classification MD"] [list [export_vars -base "classification" {ims_md_id ims_md_cl_id ims_md_cl_ta_id}] "Classification Entry"] [list [export_vars -base "classification_tpath" {ims_md_id ims_md_cl_id ims_md_cl_ta_id}] "Taxonomic Paths"] "Add Taxonomy"]
    set title "Add Classification MD Taxonomic Path Taxonomy"
}

# Form

ad_form -name classificationmd_taxon \
    -cancel_url classification_tpath?ims_md_id=$ims_md_id&ims_md_cl_id=$ims_md_cl_id&ims_md_cl_ta_id=$ims_md_cl_ta_id \
    -mode edit \
    -form {

    ims_md_cl_ta_ta_id:key(ims_md_classification_taxpath_taxon_seq)

    {identifier:text,nospell
	{section "Add/Edit Classification MD Taxonomic Path Taxonomy"}	
	{html {size 50}}
	{help_text "Taxon's identifier in taxonomic system"}
	{label "Identifier:"}
    }

    {entry_l:text,nospell	
	{html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
	{label "Language:"}
    }

    {entry_s:text,nospell	
	{html {size 50}}
	{help_text "Number in the Catalog i.e.: '1.3.1'"}
	{label "Entry:"}
    }
    
    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

    {ims_md_cl_id:text(hidden) {value $ims_md_cl_id}
    }

    {ims_md_cl_ta_id:text(hidden) {value $ims_md_cl_ta_id}
    }

} -select_query  {select * from ims_md_classification_taxpath_taxon where ims_md_cl_ta_ta_id = :ims_md_cl_ta_ta_id and ims_md_cl_ta_id = :ims_md_cl_ta_id

} -edit_data {
        db_dml do_update "
            update ims_md_classification_taxpath_taxon
            set identifier = :identifier,
            entry_l = :entry_l,
            entry_s = :entry_s
            where ims_md_cl_ta_ta_id = :ims_md_cl_ta_ta_id"

} -new_data {
        db_dml do_insert "
            insert into ims_md_classification_taxpath_taxon (ims_md_cl_ta_ta_id, ims_md_cl_ta_id, identifier, entry_l, entry_s)
            values 
            (:ims_md_cl_ta_ta_id, :ims_md_cl_ta_id, :identifier, :entry_l, :entry_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "classification_tpath" {ims_md_cl_ta_id ims_md_cl_id ims_md_id}]
        ad_script_abort
} 

# Classification Taxonomic Path Taxonomy
template::list::create \
    -name d_cl_taxon \
    -multirow d_cl_taxon \
    -no_data "No Taxonomies Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	identifier {
	    label "ID"
	}
	entry {
	    label "Entry"
	}
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "classification_taxon" {ims_md_cl_ta_ta_id ims_md_cl_ta_id ims_md_cl_id ims_md_id}] }
            link_html {title "Edit Record"}
            html { align center }
        }
    }

db_multirow d_cl_taxon select_cl_taxon {
    select ctt.identifier,
    '[' || ctt.entry_l || '] ' || ctt.entry_s as entry,
    ctt.ims_md_cl_ta_id,
    ctt.ims_md_cl_ta_ta_id,
    cl.ims_md_cl_id,
    cl.ims_md_id
    from 
           ims_md_classification_taxpath_taxon ctt,
           ims_md_classification cl
    where
           ctt.ims_md_cl_ta_id = :ims_md_cl_ta_id
    and
           cl.ims_md_cl_id = :ims_md_cl_id
} 
