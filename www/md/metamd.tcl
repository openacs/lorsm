ad_page_contract {
    Displays/Adds IMS Metadata Metametadata

    @author Ernie Ghiglione (ErnieG@ee.usyd.edu.au)
    @creation-date 30 January 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list "IMS Metadata Editor - Metadata MD"]
set title "Metadata MD"

# Metametadata Catalogentry
template::list::create \
    -name d_md_cata \
    -multirow d_md_cata \
    -no_data "No Catalog Entry Available" \
    -actions [list "Add Catalog-Entry" [export_vars -base metamd_cata {ims_md_id}] "Add another Catalog-Entry"] \
    -html { align right style "width: 100%;" } \
    -elements {
        catalog {
            label "Catalog"
        }
        entry_ls {
            label "\Language\ Entry"
        }
    }

db_multirow d_md_cata select_md_cata {
    select 
           catalog,
    '[' || entry_l || ']' || ' ' || entry_s as entry_ls
    from 
           ims_md_metadata_cata
    where
           ims_md_id = :ims_md_id
} 


# Metametadata Contrib
template::list::create \
    -name d_md_cont \
    -multirow d_md_cont \
    -no_data "No Contributors Available" \
    -actions [list "Add Contributors" [export_vars -base metamd_cont {ims_md_id}] "Add another Contributors"] \
    -html { align right style "width: 100%;" } \
    -elements {
        role {
            label "Role"
        }
        entity {
            label "Entity"
        }
        cont_date {
            label "Contribution Date"
        }
        cont_date_ls {
            label "Description"
        }
    }

db_multirow d_md_cont select_md_cont {
select 
	mdc.role_v || ' ' || '[' || mdc.role_s || ']' as role,
    mdce.entity,
    mdc.cont_date,
    '[' || mdc.cont_date_l || ']' || ' ' || mdc.cont_date_s as cont_date_ls
from 
    ims_md_metadata_contrib mdc, 
    ims_md_metadata_contrib_entity mdce 
where 
    mdc.ims_md_md_cont_id = mdce.ims_md_md_cont_id 
and
    mdc.ims_md_id = :ims_md_id
} 

# Metametadata metadatascheme
template::list::create \
    -name d_md_scheme \
    -multirow d_md_scheme \
    -no_data "No Scheme Available" \
    -actions [list "Add Scheme" [export_vars -base metamd_scheme {ims_md_id}] "Add another Scheme"] \
    -html { align right style "width: 100%;" } \
    -elements {
        scheme {
            label ""
        }
    }

db_multirow d_md_scheme select_md_scheme {
    select 
           scheme
    from 
           ims_md_metadata_scheme
    where
           ims_md_id = :ims_md_id
} 

# Metametadata language
template::list::create \
    -name d_md_lang \
    -multirow d_md_lang \
    -no_data "No Language Available" \
    -actions [list "Add Language" [export_vars -base metamd_lang {ims_md_id}] "Add another Languages"] \
    -html { align right style "width: 100%;" } \
    -elements {
        language {
            label ""
        }
    }

db_multirow d_md_lang select_md_lang {
    select 
           language
    from 
           ims_md_metadata
    where
           ims_md_id = :ims_md_id
} 