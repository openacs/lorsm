# packages/lorsm/www/md/annotationmd/annotation_desc.tcl

ad_page_contract {
    
    Add/Edit Annotation MD Description
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_an_id:integer
    ims_md_an_de_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_an_de_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"] [list [export_vars -base "../annotationmd" ims_md_id] "Annotation MD"] [list [export_vars -base "annotation" {ims_md_id ims_md_an_id}] "Annotation Entry"] "Edit Description"]
    set title "Edit Annotation MD Description"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"] [list [export_vars -base "../annotationmd" ims_md_id] "Annotation MD"] [list [export_vars -base "annotation" {ims_md_id ims_md_an_id}] "Annotation Entry"] "Add Description"]
    set title "Add Annotation MD Description"
}

# Form

ad_form -name annotationmd_desc \
    -cancel_url annotation?ims_md_id=$ims_md_id&ims_md_an_id=$ims_md_an_id \
    -mode edit \
    -form {

    ims_md_an_de_id:key(ims_md_annotation_descrip_seq)

    {descrip_l:text,nospell
	{section "Add/Edit Annotation MD Description"}	
	{html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
	{label "Language:"}
    }

    {descrip_s:text(textarea),nospell	
	{html {rows 2 cols 50}}
	{help_text "Content of the annotation"}
	{label "Description:"}
    }
    
    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

    {ims_md_an_id:text(hidden) {value $ims_md_an_id}
    }

} -select_query  {select * from ims_md_annotation_descrip where ims_md_an_de_id = :ims_md_an_de_id and ims_md_an_id = :ims_md_an_id

} -edit_data {
        db_dml do_update "
            update ims_md_annotation_descrip
            set descrip_l = :descrip_l,
            descrip_s = :descrip_s
            where ims_md_an_de_id = :ims_md_an_de_id"

} -new_data {
        db_dml do_insert "
            insert into ims_md_annotation_descrip (ims_md_an_de_id, ims_md_an_id, descrip_l, descrip_s)
            values 
            (:ims_md_an_de_id, :ims_md_an_id, :descrip_l, :descrip_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "annotation" {ims_md_an_id ims_md_id}]
        ad_script_abort
} 

# Annotation Description
template::list::create \
    -name d_an_desc \
    -multirow d_an_desc \
    -no_data "No Description Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	desc {
	    label ""
	}
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "annotation_desc" {ims_md_an_de_id ims_md_an_id ims_md_id}] }
            link_html {title "Edit Record"}
            html { align center }
        }
    }

db_multirow d_an_desc select_an_desc {
    select
    '[' || ande.descrip_l || '] ' || ande.descrip_s as desc,
    ande.ims_md_an_de_id,
    an.ims_md_an_id,
    an.ims_md_id
    from 
           ims_md_annotation_descrip ande,
           ims_md_annotation an
    where
           ande.ims_md_an_id = an.ims_md_an_id
    and
           ande.ims_md_an_id = :ims_md_an_id
} 
