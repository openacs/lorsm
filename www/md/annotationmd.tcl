ad_page_contract {
    Displays/Adds IMS Metadata Annotation

    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list [list [export_vars -base "." ims_md_id] "IMS Metadata Editor"]  "Annotation MD"]
set title "Annotation MD"

# Annotation
template::list::create \
    -name d_an_annot \
    -multirow d_an_annot \
    -no_data "No Annotation Available" \
    -actions [list "Add Annotation" [export_vars -base annotationmd/annotation_add {ims_md_id}] "Add another Annotation MD Entry"] \
    -html { align right style "width: 100%;" } \
    -elements {
        entity {
            label "Entry"
        }
	export {
            display_eval {\[View\]}
            link_url_eval { [export_vars -base "annotationmd/annotation" {ims_md_an_id ims_md_id}] }
            link_html {title "View associated Annotation MD"}
            html { align center }
        }
    }

db_multirow d_an_annot select_an_annot {
select 
    entity,
    ims_md_an_id,
    ims_md_id
from 
    ims_md_annotation 
where 
    ims_md_id = :ims_md_id
} 
