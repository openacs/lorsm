# packages/lorsm/www/md/relationmd/relation_cata.tcl

ad_page_contract {
    
    Add/Edit Relation MD Resource Catalog-Entry
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_re_id:integer
    ims_md_re_re_id:integer
    ims_md_re_re_ca_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_re_re_ca_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../relationmd" ims_md_id] "Relation MD"] [list [export_vars -base "relation" {ims_md_id ims_md_re_id ims_md_re_re_id}] "Relation Entry"] "Edit Catalog-Entry"]
    set title "Edit Relation MD Resource Catalog-Entry"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../relationmd" ims_md_id] "Relation MD"] [list [export_vars -base "relation" {ims_md_id ims_md_re_id ims_md_re_re_id}] "Relation Entry"] "Add Catalog-Entry"]
    set title "Add Relation MD Resource Catalog-Entry"
}

# Form

ad_form -name relationmd_cata \
    -cancel_url relation?ims_md_id=$ims_md_id&ims_md_re_id=$ims_md_re_id&ims_md_re_re_id=$ims_md_re_re_id \
    -mode edit \
    -form {

    ims_md_re_re_ca_id:key(ims_md_relation_resource_catalog_seq)

    {catalog:text,nospell
	{section "Add/Edit Relation MD Resource Catalog-Entry"}	
	{html {size 50}}
	{help_text "Name of the catalog"}
	{label "Catalog:"}
    }

    {entry_l:text,nospell,optional	
	{html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
	{label "Language:"}
    }

    {entry_s:text,nospell
        {html {size 50}}
	{help_text "Number in the Catalog i.e.: '1.3.1'"}
        {label "Entry:"}
    }
    
    {ims_md_re_re_id:text(hidden) {value $ims_md_re_re_id}
    } 

    {ims_md_re_id:text(hidden) {value $ims_md_re_id}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_relation_resource_catalog where ims_md_re_re_ca_id = :ims_md_re_re_ca_id and ims_md_re_re_id = :ims_md_re_re_id

} -edit_data {
        db_dml do_update "
            update ims_md_relation_resource_catalog
            set catalog = :catalog,
            entry_l = :entry_l,
            entry_s = :entry_s
            where ims_md_re_re_ca_id = :ims_md_re_re_ca_id"

} -new_data {
        db_dml do_insert "
            insert into ims_md_relation_resource_catalog (ims_md_re_re_ca_id, ims_md_re_re_id, catalog, entry_l, entry_s)
            values 
            (:ims_md_re_re_ca_id, :ims_md_re_re_id, :catalog, :entry_l, :entry_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "relation" {ims_md_re_id ims_md_re_re_id ims_md_id}]
        ad_script_abort
} 

# Relation Catalog-Entry
template::list::create \
    -name d_re_cata \
    -multirow d_re_cata \
    -no_data "No Catalog-Entries Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	catalog {
	    label ""
	}
	entry_l {
	    label ""
	}
	entry_s {
	    label ""
	}
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "relation_cata" {ims_md_re_re_ca_id ims_md_re_re_id ims_md_re_id ims_md_id}] }
            link_html {title "Edit Record"}
            html { align center }
        }
    }

db_multirow d_re_cata select_re_cata {
    select
    reca.catalog,
    reca.entry_l,
    reca.entry_s,
    reca.ims_md_re_re_ca_id,
    reca.ims_md_re_re_id,
    re.ims_md_id,
    re.ims_md_re_id
    from 
           ims_md_relation_resource_catalog reca,
           ims_md_relation re
    where
           reca.ims_md_re_re_id = :ims_md_re_re_id
    and
           re.ims_md_re_id = :ims_md_re_id
} 
