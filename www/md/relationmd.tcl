ad_page_contract {
    Displays/Adds IMS Metadata Relation

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 30 January 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}


# Rights Cost
template::list::create \
    -name d_re_kind \
    -multirow d_ri_cost \
    -no_data "No Cost Available" \
    -actions [list "Add Cost" [export_vars -base educationalmd_cost {ims_md_id}] "Add another Cost"] \
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
