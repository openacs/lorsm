ad_page_contract {
    Displays/Adds IMS Metadata Lifecycle

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 30 January 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list [list [export_vars -base "." ims_md_id] "IMS Metadata Editor"]  "Lifecycle MD"]

set title "Lifecycle MD"

# Lifecycle version
template::list::create \
    -name d_lf_ver \
    -multirow d_lf_ver \
    -no_data "[_ lorsm.No_Version_Available]" \
    -actions [list "[_ lorsm.Add_Version]" [export_vars -base lifecyclemd/lifecycle_version {ims_md_id}] "[_ lorsm.Add_Version]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        version_l {
            label ""
        }
        version_s {
            label ""
        }
    }

db_multirow d_lf_ver select_lf_ver {} 

# Lifecycle status
template::list::create \
    -name d_lf_stat \
    -multirow d_lf_stat \
    -no_data "[_ lorsm.No_Status_Available]" \
    -actions [list "[_ lorsm.Add_Status]" [export_vars -base lifecyclemd/lifecycle_stat {ims_md_id}] "[_ lorsm.Add_Status]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        status_s {
            label ""
        }
        status_v {
            label ""
        }
    }

db_multirow d_lf_stat select_lf_stat {} 


# Lifecycle Contrib
template::list::create \
    -name d_lf_cont \
    -multirow d_lf_cont \
    -no_data "[_ lorsm.lt_No_Contributors_Avail]" \
    -actions [list "[_ lorsm.Add_Contributors]" [export_vars -base lifecyclemd/lifecycle_cont {ims_md_id}] "[_ lorsm.lt_Add_another_Contribut]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        role {
            label "[_ lorsm.Role]"
	    display_eval {[concat $role_v \[$role_s\]]}
        }
        entity {
            label "[_ lorsm.Entity_1]"
        }
        cont_date {
            label "[_ lorsm.Contribution_Date]"
        }
        cont_date_ls {
            label "[_ lorsm.Description_1]"
	    display_eval {[concat $cont_date_l \[$cont_date_s\]]}
        }
    }

db_multirow d_lf_cont select_lf_cont {}