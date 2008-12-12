# packages/lorsm/www/md/rightsmd/rights_cost.tcl

ad_page_contract {

    Add/Edit Rights MD Cost

    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title
set context [list \
                [list   [export_vars -base ".." ims_md_id] \
                        "[_ lorsm.IMS_Metadata_Editor]"] \

                [list   [export_vars -base "../rightsmd" ims_md_id] \
                        "[_ lorsm.Rights_MD]"] \

                "[_ lorsm.AddEdit_Cost]"]
set title "[_ lorsm.lt_AddEdit_Rights_MD_Cos]"


# Form

ad_form \
    -name rightsmd_cost \
    -cancel_url ../rightsmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {
        {cost_s:text,nospell
            {html {size 10}}
            {help_text "[_ lorsm.lt_Source_of_vocabulary_]"}
            {label "[_ lorsm.Source]"}
        }

        {cost_v:text,nospell
            {html {size 10}}
            {help_text "[_ lorsm.lt_Whether_use_of_the_re]"}
            {label "[_ lorsm.Cost]"}
        }

        {ims_md_id:text(hidden) {value $ims_md_id}}

    } -on_submit {
        # check if the Rights Cost details already exist...

        if {[db_0or1row select_type {}]} {
            db_dml do_update {}
        } else {
            db_dml do_insert {}
        }

    } -after_submit {
        ad_returnredirect [export_vars -base "../rightsmd" {ims_md_id}]
        ad_script_abort
    }

# Rights Cost
template::list::create \
    -name d_ri_cost \
    -multirow d_ri_cost \
    -no_data "[_ lorsm.No_Cost_Available]" \
    -html { align right style "width: 100%;" } \
    -elements {
        cost { label "[_ lorsm.Cost_1]" }
    }

db_multirow d_ri_cost select_ri_cost {}
