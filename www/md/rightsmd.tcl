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
set title "Rights MD"

# Rights Cost
template::list::create \
    -name d_ri_cost \
    -multirow d_ri_cost \
    -no_data "No Cost Available" \
    -actions [list "Add Cost" [export_vars -base rightsmd/rights_cost {ims_md_id}] "Add another Cost"] \
    -html { align right style "width: 100%;" } \
    -elements {
        cost {
            label ""
        }
    }

db_multirow d_ri_cost select_ri_cost {
    select 
    '[' || cost_s || '] ' || cost_v as cost
    from 
           ims_md_rights
    where
           ims_md_id = :ims_md_id
} 

# Rights Copyright or other Restrictions 
template::list::create \
    -name d_ri_caor \
    -multirow d_ri_caor \
    -no_data "No Copyright or other Restrictions Available" \
    -actions [list "Add Copyright or other Restrictions" [export_vars -base rightsmd/rights_caor {ims_md_id}] "Add another Copyright or other Restrictions"] \
    -html { align right style "width: 100%;" } \
    -elements {
        caor {
            label ""
        }
    }

db_multirow d_ri_caor select_ri_caor {
    select 
    '[' || caor_s || '] ' || caor_v as caor
    from 
           ims_md_rights
    where
           ims_md_id = :ims_md_id
} 

# Rights Description
template::list::create \
    -name d_ri_desc \
    -multirow d_ri_desc \
    -no_data "No Description Available" \
    -actions [list "Add Description" [export_vars -base rightsmd/rights_desc {ims_md_id}] "Add another Description"] \
    -html { align right style "width: 100%;" } \
    -elements {
        desc {
            label ""
        }
    }

db_multirow d_ri_desc select_ri_desc {
    select 
    '[' || descrip_l || '] ' || descrip_s as desc
    from 
           ims_md_rights
    where
           ims_md_id = :ims_md_id
} 
