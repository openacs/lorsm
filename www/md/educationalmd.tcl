ad_page_contract {
    Displays/Adds IMS Metadata Educational

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 30 January 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list "IMS Metadata Editor - Educational MD"]
set title "Educational MD"

# Educational Interactivity Type
template::list::create \
    -name d_ed_intt \
    -multirow d_ed_intt \
    -no_data "No Interactivity Type Available" \
    -actions [list "Add Interactivity Type" [export_vars -base educationalmd_intt {ims_md_id}] "Add another Interactivity Type"] \
    -html { align right style "width: 100%;" } \
    -elements {
        intt {
            label ""
        }
    }

db_multirow d_ed_intt select_ed_intt {
    select 
    '[' || int_type_s || '] ' || int_type_v as intt 
    from 
           ims_md_educational
    where
           ims_md_id = :ims_md_id
} 

# Educational Learning Resource Type
template::list::create \
    -name d_ed_lrt \
    -multirow d_ed_lrt \
    -no_data "No Learning Resource Type Available" \
    -actions [list "Add Learning Resource Type" [export_vars -base educationalmd_lrt {ims_md_id}] "Add another Learning Resource Type"] \
    -html { align right style "width: 100%;" } \
    -elements {
        lrt {
            label ""
        }
    }

db_multirow d_ed_lrt select_ed_lrt {
    select 
    '[' || lrt_s || '] ' || lrt_v as lrt 
    from 
           ims_md_educational_lrt
    where
           ims_md_id = :ims_md_id
} 

# Educational Interactivity Level
template::list::create \
    -name d_ed_intl \
    -multirow d_ed_intl \
    -no_data "No Interactivity Level Available" \
    -actions [list "Add Interactivity Level" [export_vars -base educationalmd_intl {ims_md_id}] "Add another Interactivity Level"] \
    -html { align right style "width: 100%;" } \
    -elements {
        intl {
            label ""
        }
    }

db_multirow d_ed_intl select_ed_intl {
    select 
    '[' || int_level_s || '] ' || int_level_v as intl 
    from 
           ims_md_educational
    where
           ims_md_id = :ims_md_id
} 

# Educational Semantic Density
template::list::create \
    -name d_ed_semd \
    -multirow d_ed_semd \
    -no_data "No Semantic Density Available" \
    -actions [list "Add Semantic Density" [export_vars -base educationalmd_semd {ims_md_id}] "Add another Semantic Density"] \
    -html { align right style "width: 100%;" } \
    -elements {
        semd {
            label ""
        }
    }

db_multirow d_ed_semd select_ed_semd {
    select 
    '[' || sem_density_s || '] ' || sem_density_v as semd
    from 
           ims_md_educational
    where
           ims_md_id = :ims_md_id
} 

# Educational Intended End User Role
template::list::create \
    -name d_ed_ieur \
    -multirow d_ed_ieur \
    -no_data "No Intended End User Role Available" \
    -actions [list "Add Intended End User Role" [export_vars -base educationalmd_ieur {ims_md_id}] "Add another Intended End User Role"] \
    -html { align right style "width: 100%;" } \
    -elements {
        ieur {
            label ""
        }
    }

db_multirow d_ed_ieur select_ed_ieur {
    select 
    '[' || ieur_s || '] ' || ieur_v as ieur 
    from 
           ims_md_educational_ieur
    where
           ims_md_id = :ims_md_id
} 

# Educational Context
template::list::create \
    -name d_ed_cont \
    -multirow d_ed_cont \
    -no_data "No Context Available" \
    -actions [list "Add Context" [export_vars -base educationalmd_cont {ims_md_id}] "Add another Context"] \
    -html { align right style "width: 100%;" } \
    -elements {
        context {
            label ""
        }
    }

db_multirow d_ed_cont select_ed_cont {
    select 
    '[' || context_s || '] ' || context_v as context 
    from 
           ims_md_educational_context
    where
           ims_md_id = :ims_md_id
} 

# Educational Typical Age Range
template::list::create \
    -name d_ed_tar \
    -multirow d_ed_tar \
    -no_data "No Typical Age Range Available" \
    -actions [list "Add Typical Age Range" [export_vars -base educationalmd_tar {ims_md_id}] "Add another Typical Age Range"] \
    -html { align right style "width: 100%;" } \
    -elements {
        tar {
            label ""
        }
    }

db_multirow d_ed_tar select_ed_tar {
    select 
    '[' || tar_l || '] ' || tar_s as tar 
    from 
           ims_md_educational_tar
    where
           ims_md_id = :ims_md_id
} 

# Educational Difficulty
template::list::create \
    -name d_ed_dif \
    -multirow d_ed_dif \
    -no_data "No Difficulty Available" \
    -actions [list "Add Difficulty Type" [export_vars -base educationalmd_dif {ims_md_id}] "Add another Difficulty"] \
    -html { align right style "width: 100%;" } \
    -elements {
        diff {
            label ""
        }
    }

db_multirow d_ed_dif select_ed_dif {
    select 
    '[' || difficulty_s || '] ' || difficulty_v as diff
    from 
           ims_md_educational
    where
           ims_md_id = :ims_md_id
} 

# Educational Typical Learning Time
template::list::create \
    -name d_ed_tlt \
    -multirow d_ed_tlt \
    -no_data "No Typical Learning Time Available" \
    -actions [list "Add Typical Learning Time" [export_vars -base educationalmd_tlt {ims_md_id}] "Add another Typical Learning Time"] \
    -html { align right style "width: 100%;" } \
    -elements {
        tlt {
            label ""
        }
        tlt_ls {
            label ""
        }
    }

db_multirow d_ed_tlt select_ed_tlt {
    select 
    type_lrn_time as tlt,
    '[' || type_lrn_time_l || '] ' || type_lrn_time_s as tlt_ls
    from 
           ims_md_educational
    where
           ims_md_id = :ims_md_id
} 

# Educational Description
template::list::create \
    -name d_ed_desc \
    -multirow d_ed_desc \
    -no_data "No Description Available" \
    -actions [list "Add Description" [export_vars -base educationalmd_tlt {ims_md_id}] "Add another Description"] \
    -html { align right style "width: 100%;" } \
    -elements {
        desc {
            label ""
        }
    }

db_multirow d_ed_desc select_ed_desc {
    select 
    '[' || descrip_l || '] ' || descrip_s as desc
    from 
           ims_md_educational_descrip
    where
           ims_md_id = :ims_md_id
} 

# Educational Language
template::list::create \
    -name d_ed_lang \
    -multirow d_ed_lang \
    -no_data "No Language Available" \
    -actions [list "Add Language" [export_vars -base educationalmd_lang {ims_md_id}] "Add another Language"] \
    -html { align right style "width: 100%;" } \
    -elements {
        language {
            label ""
        }
    }

db_multirow d_ed_lang select_ed_lang {
    select 
           language
    from 
           ims_md_educational_lang
    where
           ims_md_id = :ims_md_id
} 