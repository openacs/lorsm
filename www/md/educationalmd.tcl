ad_page_contract {
    Displays/Adds IMS Metadata Educational

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 30 January 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list [list [export_vars -base "." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  "[_ lorsm.Educational_MD]"]
set title "[_ lorsm.Educational_MD]"

# Educational Interactivity Type
template::list::create \
    -name d_ed_intt \
    -multirow d_ed_intt \
    -no_data "[_ lorsm.lt_No_Interactivity_Type]" \
    -actions [list "[_ lorsm.lt_Add_Interactivity_Typ]" [export_vars -base educationalmd/educational_intt {ims_md_id}] "[_ lorsm.lt_Add_another_Interacti]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        intt {
            label ""
	    display_eval {[concat \[$int_type_s\] $int_type_v]}
        }
    }

db_multirow d_ed_intt select_ed_intt {} 

# Educational Learning Resource Type
template::list::create \
    -name d_ed_lrt \
    -multirow d_ed_lrt \
    -no_data "[_ lorsm.lt_No_Learning_Resource_]" \
    -actions [list "[_ lorsm.lt_Add_Learning_Resource]" [export_vars -base educationalmd/educational_lrt {ims_md_id}] "[_ lorsm.lt_Add_another_Learning_]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        lrt {
            label ""
	    display_eval {[concat \[$lrt_s\] $lrt_v]}
        }
    }

db_multirow d_ed_lrt select_ed_lrt {} 

# Educational Interactivity Level
template::list::create \
    -name d_ed_intl \
    -multirow d_ed_intl \
    -no_data "[_ lorsm.lt_No_Interactivity_Leve]" \
    -actions [list "[_ lorsm.lt_Add_Interactivity_Lev]" [export_vars -base educationalmd/educational_intl {ims_md_id}] "[_ lorsm.lt_Add_another_Interacti_1]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        intl {
            label ""
	    display_eval {[concat \[$int_level_s\] $int_level_v]}
        }
    }

db_multirow d_ed_intl select_ed_intl {} 

# Educational Semantic Density
template::list::create \
    -name d_ed_semd \
    -multirow d_ed_semd \
    -no_data "[_ lorsm.lt_No_Semantic_Density_A]" \
    -actions [list "[_ lorsm.Add_Semantic_Density]" [export_vars -base educationalmd/educational_semd {ims_md_id}] "[_ lorsm.lt_Add_another_Semantic_]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        semd {
            label ""
	    display_eval {[concat \[$sem_density_s\] $sem_density_v]}
        }
    }

db_multirow d_ed_semd select_ed_semd {} 

# Educational Intended End User Role
template::list::create \
    -name d_ed_ieur \
    -multirow d_ed_ieur \
    -no_data "[_ lorsm.lt_No_Intended_End_User_]" \
    -actions [list "[_ lorsm.lt_Add_Intended_End_User]" [export_vars -base educationalmd/educational_ieur {ims_md_id}] "[_ lorsm.lt_Add_another_Intended_]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        ieur {
            label ""
	    display_eval {[concat \[$ieur_s\] $ieur_v]}
        }
    }

db_multirow d_ed_ieur select_ed_ieur {} 

# Educational Context
template::list::create \
    -name d_ed_cont \
    -multirow d_ed_cont \
    -no_data "[_ lorsm.No_Context_Available]" \
    -actions [list "[_ lorsm.Add_Context]" [export_vars -base educationalmd/educational_cont {ims_md_id}] "[_ lorsm.Add_another_Context]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        context {
            label ""
	    display_eval {[concat \[$context_s\] $context_v]}
        }
    }

db_multirow d_ed_cont select_ed_cont {} 

# Educational Typical Age Range
template::list::create \
    -name d_ed_tar \
    -multirow d_ed_tar \
    -no_data "[_ lorsm.lt_No_Typical_Age_Range_]" \
    -actions [list "[_ lorsm.lt_Add_Typical_Age_Range]" [export_vars -base educationalmd/educational_tar {ims_md_id}] "[_ lorsm.lt_Add_another_Typical_A]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        tar {
            label ""
	    display_eval {[concat \[$tar_l\] $tar_s]}
        }
    }

db_multirow d_ed_tar select_ed_tar {} 

# Educational Difficulty
template::list::create \
    -name d_ed_dif \
    -multirow d_ed_dif \
    -no_data "[_ lorsm.lt_No_Difficulty_Availab]" \
    -actions [list "[_ lorsm.Add_Difficulty_Type]" [export_vars -base educationalmd/educational_dif {ims_md_id}] "[_ lorsm.lt_Add_another_Difficult]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        diff {
            label ""
	    display_eval {[concat \[$difficulty_s\] $difficulty_v]}
        }
    }

db_multirow d_ed_dif select_ed_dif {} 

# Educational Typical Learning Time
template::list::create \
    -name d_ed_tlt \
    -multirow d_ed_tlt \
    -no_data "[_ lorsm.lt_No_Typical_Learning_T]" \
    -actions [list "[_ lorsm.lt_Add_Typical_Learning_]" [export_vars -base educationalmd/educational_tlt {ims_md_id}] "[_ lorsm.lt_Add_another_Typical_L]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        tlt {
            label ""
        }
        tlt_ls {
            label ""
	    display_eval {[concat \[$type_lrn_time_l\] $type_lrn_time_s]}
        }
    }

db_multirow d_ed_tlt select_ed_tlt {} 

# Educational Description
template::list::create \
    -name d_ed_desc \
    -multirow d_ed_desc \
    -no_data "[_ lorsm.lt_No_Description_Availa]" \
    -actions [list "[_ lorsm.Add_Description]" [export_vars -base educationalmd/educational_desc {ims_md_id}] "[_ lorsm.lt_Add_another_Descripti]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        descrip {
            label ""
	    display_eval {[concat \[$descrip_l\] $descrip_s]}
        }
    }

db_multirow d_ed_desc select_ed_desc {} 

# Educational Language
template::list::create \
    -name d_ed_lang \
    -multirow d_ed_lang \
    -no_data "[_ lorsm.lt_No_Language_Available]" \
    -actions [list "[_ lorsm.Add_Language]" [export_vars -base educationalmd/educational_lang {ims_md_id}] "[_ lorsm.Add_another_Language]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        language {
            label ""
        }
    }

db_multirow d_ed_lang select_ed_lang {} 
