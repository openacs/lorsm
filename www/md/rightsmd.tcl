ad_page_contract {
    Displays/Adds IMS Metadata Rights

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 30 January 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list [list [export_vars -base "." ims_md_id] "IMS Metadata Editor"]  "Rights MD"]
set title "[_ lorsm.Rights_MD]"

# Rights Cost
template::list::create \
    -name d_ri_cost \
    -multirow d_ri_cost \
    -no_data "[_ lorsm.No_Cost_Available]" \
    -actions [list "[_ lorsm.Add_Cost]" [export_vars -base rightsmd/rights_cost {ims_md_id}] "[_ lorsm.Add_another_Cost]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        cost {
            label ""
	    display_eval {[concat \[$cost_s\] $cost_v]}
        }
    }

db_multirow d_ri_cost select_ri_cost {} 

# Rights Copyright or other Restrictions 
template::list::create \
    -name d_ri_caor \
    -multirow d_ri_caor \
    -no_data "[_ lorsm.lt_No_Copyright_or_other]" \
    -actions [list "[_ lorsm.lt_Add_Copyright_or_othe]" [export_vars -base rightsmd/rights_caor {ims_md_id}] "[_ lorsm.lt_Add_another_Copyright]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        caor {
            label ""
	    display_eval {[concat \[$caor_s\] $caor_v]}
        }
    }

db_multirow d_ri_caor select_ri_caor {} 

# Rights Description
template::list::create \
    -name d_ri_desc \
    -multirow d_ri_desc \
    -no_data "[_ lorsm.lt_No_Description_Availa]" \
    -actions [list "[_ lorsm.Add_Description]" [export_vars -base rightsmd/rights_desc {ims_md_id}] "[_ lorsm.lt_Add_another_Descripti]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        descrip {
            label ""
	    display_eval {[concat \[$descrip_l\] $descrip_s]}
        }
    }

db_multirow d_ri_desc select_ri_desc {} 
