# packages/lorsm/www/md/annotationmd/annotation_ent.tcl

ad_page_contract {
    
    Add/Edit Annotation MD Entity
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_an_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"] [list [export_vars -base "../annotationmd" ims_md_id] "Annotation MD"] [list [export_vars -base "annotation" {ims_md_id ims_md_an_id}] "Annotation Entry"] "Add/Edit Entity"]
set title "Edit Annotation MD Entity"


# Form

ad_form -name annotationmd_ent \
    -cancel_url annotation?ims_md_id=$ims_md_id&ims_md_an_id=$ims_md_an_id \
    -mode edit \
    -form {

    ims_md_an_id:key(ims_md_annotation_seq)

    {entity:text(textarea),nospell
	{section "Add/Edit Annotation MD Entity"}
        {html {rows 5 cols 50}}
	{help_text "Annotator"}
        {label "Entity:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

} -select_query  {select * from ims_md_annotation where ims_md_an_id = :ims_md_an_id

} -edit_data {
        db_dml do_update "
            update ims_md_annotation
            set entity = :entity
            where ims_md_an_id = :ims_md_an_id "

} -after_submit {
    ad_returnredirect [export_vars -base "annotation" {ims_md_an_id ims_md_id}]
        ad_script_abort
} 

# Annotation Entity
template::list::create \
    -name d_an_ent \
    -multirow d_an_ent \
    -no_data "No Entity Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	entity {
            label ""
        }
    }

db_multirow d_an_ent select_an_ent {
    select 
        entity,
        ims_md_an_id,
        ims_md_id
    from 
           ims_md_annotation
    where
           ims_md_an_id = :ims_md_an_id
} 
