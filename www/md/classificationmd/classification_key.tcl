# packages/lorsm/www/md/classificationmd/classification_key.tcl

ad_page_contract {
    
    Add/Edit Classification MD Keyword
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_cl_id:integer
    ims_md_cl_ke_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_cl_ke_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"] [list [export_vars -base "../classificationmd" ims_md_id] "Classification MD"] [list [export_vars -base "classification" {ims_md_id ims_md_cl_id}] "Classification Entry"] "Edit Keyword"]
    set title "Edit Classification MD Keyword"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"] [list [export_vars -base "../classificationmd" ims_md_id] "Classification MD"] [list [export_vars -base "classification" {ims_md_id ims_md_cl_id}] "Classification Entry"] "Add Keyword"]
    set title "Add Classification MD Keyword"
}

# Form

ad_form -name classificationmd_key \
    -cancel_url classification?ims_md_id=$ims_md_id&ims_md_cl_id=$ims_md_cl_id \
    -mode edit \
    -form {

    ims_md_cl_ke_id:key(ims_md_classification_keyword_seq)

    {keyword_l:text,nospell
	{section "Add/Edit Classification MD Keyword"}	
	{html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
	{label "Language:"}
    }

    {keyword_s:text,nospell	
	{html {size 20}}
	{help_text "Keyword description of the resource"}
	{label "Keyword:"}
    }
    
    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

    {ims_md_cl_id:text(hidden) {value $ims_md_cl_id}
    }

} -select_query  {select * from ims_md_classification_keyword where ims_md_cl_ke_id = :ims_md_cl_ke_id and ims_md_cl_id = :ims_md_cl_id

} -edit_data {
        db_dml do_update "
            update ims_md_classification_keyword
            set keyword_l = :keyword_l,
            keyword_s = :keyword_s
            where ims_md_cl_ke_id = :ims_md_cl_ke_id"

} -new_data {
        db_dml do_insert "
            insert into ims_md_classification_keyword (ims_md_cl_ke_id, ims_md_cl_id, keyword_l, keyword_s)
            values 
            (:ims_md_cl_ke_id, :ims_md_cl_id, :keyword_l, :keyword_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "classification" {ims_md_cl_id ims_md_id}]
        ad_script_abort
} 

# Classification Keyword
template::list::create \
    -name d_cl_key \
    -multirow d_cl_key \
    -no_data "No Keyword Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	keyword {
	    label ""
	}
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "classification_key" {ims_md_cl_ke_id ims_md_cl_id ims_md_id}] }
            link_html {title "Edit Record"}
            html { align center }
        }
    }

db_multirow d_cl_key select_cl_key {
    select
    '[' || kw.keyword_l || '] ' || kw.keyword_s as keyword,
    kw.ims_md_cl_ke_id,
    cl.ims_md_cl_id,
    cl.ims_md_id
    from 
           ims_md_classification_keyword kw,
           ims_md_classification cl
    where
           kw.ims_md_cl_id = cl.ims_md_cl_id
    and
           kw.ims_md_cl_id = :ims_md_cl_id
} 
