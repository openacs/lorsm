# packages/lorsm/www/md/generalmd.tcl

ad_page_contract {
    Displays/Adds IMS Metadata General

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 19 January 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list [list [export_vars -base "." ims_md_id] "IMS Metadata Editor"]  "General MD"]
set title "General MD"

# General Title
template::list::create \
    -name d_gen_titles \
    -multirow d_gen_titles \
    -no_data "No Titles Available" \
    -actions [list "Add Title" [export_vars -base generalmd/general_title {ims_md_id}] "Add another title"] \
    -html { align right style "width: 100%;" } \
    -elements {
        title_l {
            label ""
        }
        title_s {
            label ""
        }
    }

db_multirow d_gen_titles select_ge_titles {
    select title_l,
           title_s
    from 
           ims_md_general_title
    where
           ims_md_id = :ims_md_id
} {
    set item_url [export_vars -base "item" { ims_md_id }]
}

# General Description
template::list::create \
    -name d_gen_desc \
    -multirow d_gen_desc \
    -no_data "No Description Available" \
    -actions [list "Add Description" [export_vars -base generalmd/general_desc {ims_md_id}] "Add another Description"] \
    -html { align right style "width: 100%;" } \
    -elements {
        descrip_l {
            label ""
        }
        descrip_s {
            label ""
        }
    }

db_multirow d_gen_desc select_ge_desc {
    select descrip_l,
           descrip_s
    from 
           ims_md_general_desc
    where
           ims_md_id = :ims_md_id
} 

# General Catalog-entry
template::list::create \
    -name d_gen_cata \
    -multirow d_gen_cata \
    -no_data "No Catalog Entry Available" \
    -actions [list "Add Catalog-Entry" [export_vars -base generalmd/general_cata {ims_md_id}] "Add another Catalog-Entry"] \
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
    }

db_multirow d_gen_cata select_ge_cata {
    select 
           catalog,
           entry_l,
           entry_s
    from 
           ims_md_general_cata
    where
           ims_md_id = :ims_md_id
} 



# General Language
template::list::create \
    -name d_gen_lang \
    -multirow d_gen_lang \
    -no_data "No Language Available" \
    -actions [list "Add Language"  [export_vars -base generalmd/general_lang {ims_md_id}] "Add another Language"] \
    -html { align right style "width: 100%;" } \
    -elements {
        language {
            label ""
        }
    }

db_multirow d_gen_lang select_ge_lang {
    select 
           language
    from 
           ims_md_general_lang
    where
           ims_md_id = :ims_md_id
} 

# General Keywords
template::list::create \
    -name d_gen_key \
    -multirow d_gen_key \
    -no_data "No Keywords Available" \
    -actions [list "Add Keywords" [export_vars -base generalmd/general_key {ims_md_id}] "Add another Keywords"] \
    -html { align right style "width: 100%;" } \
    -elements {
        keyword_l {
            label ""
        }
        keyword_s {
            label ""
        }
    }

db_multirow d_gen_key select_ge_key {
    select 
           keyword_l,
           keyword_s
    from 
           ims_md_general_key
    where
           ims_md_id = :ims_md_id
} 

# General Coverage
template::list::create \
    -name d_gen_cover \
    -multirow d_gen_cover \
    -no_data "No Coverage Available" \
    -actions [list "Add Coverage" [export_vars -base generalmd/general_cover {ims_md_id}] "Add another Coverage"] \
    -html { align right style "width: 100%;" } \
    -elements {
        cover_l {
            label ""
        }
        cover_s {
            label ""
        }
    }

db_multirow d_gen_cover select_ge_cover {
    select 
           cover_l,
           cover_s
    from 
           ims_md_general_cover
    where
           ims_md_id = :ims_md_id
}

# General Structure
template::list::create \
    -name d_gen_struc \
    -multirow d_gen_struc \
    -no_data "No Structure Available" \
    -actions [list "Add Structure" [export_vars -base generalmd/general_struc {ims_md_id}] "Add another Structure"] \
    -html { align right style "width: 100%;" } \
    -elements {
        structure_s {
            label ""
        }
        structure_v {
            label ""
        }
    }

db_multirow d_gen_struc select_ge_struc {
    select 
           structure_s,
           structure_v
    from 
           ims_md_general
    where
           ims_md_id = :ims_md_id
}


# General Aggregation level
template::list::create \
    -name d_gen_aggl \
    -multirow d_gen_aggl \
    -no_data "No Aggregation Level  Available" \
    -actions [list "Add Aggregation Level" [export_vars -base generalmd/general_aggl {ims_md_id}]  "Add another Aggregation Level"] \
    -html { align right style "width: 100%;" } \
    -elements {
        agg_level_s {
            label ""
        }
        agg_level_v {
            label ""
        }
    }

db_multirow d_gen_aggl select_ge_aggl {
    select 
           agg_level_s,
           agg_level_v
    from 
           ims_md_general
    where
           ims_md_id = :ims_md_id
}
