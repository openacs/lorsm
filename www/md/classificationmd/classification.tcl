ad_page_contract {
    Displays/Adds IMS Metadata Classification

    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_cl_id:integer
    ims_md_id:integer
}

# set context & title
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"] [list [export_vars -base "../classificationmd" ims_md_id] "Classification MD"] "Classification Entry"]
set title "Classification MD"

# Classification Purpose
template::list::create \
    -name d_cl_pur \
    -multirow d_cl_pur \
    -no_data "No Purpose Available" \
    -actions [list "Add Purpose" [export_vars -base classification_pur {ims_md_cl_id ims_md_id}] "Add another Purpose"] \
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
           purpose_v
    from 
           ims_md_classification
    where
           ims_md_cl_id = :ims_md_cl_id
} 

# Classification Taxonomic Path 
template::list::create \
    -name d_cl_tpath \
    -multirow d_cl_tpath \
    -no_data "No Taxonomic Paths Available" \
    -actions [list "Add Taxonomic Path" [export_vars -base classification_addpath {ims_md_cl_id ims_md_id}] "Add another Taxonomic Path"] \
    -html { align right style "width: 100%;" } \
    -elements {
        source {
            label ""
        }
	export {
            display_eval {\[View\]}
            link_url_eval { [export_vars -base "classification_tpath" {ims_md_cl_ta_id ims_md_cl_id ims_md_id}] }
            link_html {title "View associated Taxonomic Path Entry"}
            html { align right }
        }
    }

db_multirow d_cl_tpath select_cl_tpath {
    select
    '[' || ctp.source_l || '] ' || ctp.source_v as source,
    ctp.ims_md_cl_ta_id,
    ctp.ims_md_cl_id,
    cl.ims_md_id
    from 
           ims_md_classification_taxpath ctp,
           ims_md_classification cl
    where
           ctp.ims_md_cl_id = :ims_md_cl_id
    and    cl.ims_md_cl_id = :ims_md_cl_id
} 

# Classification Description
template::list::create \
    -name d_cl_desc \
    -multirow d_cl_desc \
    -no_data "No Description Available" \
    -actions [list "Add Description" [export_vars -base classification_desc {ims_md_cl_id ims_md_id}] "Add another Description"] \
    -html { align right style "width: 100%;" } \
    -elements {
        desc {
            label ""
        }
    }

db_multirow d_cl_desc select_cl_desc {
    select 
    '[' || descrip_l || '] ' || descrip_s as desc
    from 
           ims_md_classification_descrip
    where
           ims_md_cl_id = :ims_md_cl_id
}

# Classification Keywords
template::list::create \
    -name d_cl_key \
    -multirow d_cl_key \
    -no_data "No Keywords Available" \
    -actions [list "Add Keyword" [export_vars -base classification_key {ims_md_cl_id ims_md_id}] "Add another Keyword"] \
    -html { align right style "width: 100%;" } \
    -elements {
        keyword {
            label ""
        }
    }

db_multirow d_cl_key select_cl_key {
    select 
    '[' || keyword_l || '] ' || keyword_s as keyword
    from 
           ims_md_classification_keyword
    where
           ims_md_cl_id = :ims_md_cl_id
}
