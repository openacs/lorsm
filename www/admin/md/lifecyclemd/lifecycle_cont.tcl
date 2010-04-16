# packages/lorsm/www/md/lifecyclemd/lifecycle_cont.tcl

ad_page_contract {

    Add/Edit Lifecycle MD Contributor

    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_lf_cont_id:integer,optional
    ims_md_lf_cont_enti_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_lf_cont_id]} {
    set context [list \
                     [list   [export_vars -base ".." ims_md_id] \
                          "[_ lorsm.IMS_Metadata_Editor]"] \
                     [list   [export_vars -base "../lifecyclemd" ims_md_id] \
                          "[_ lorsm.Life_Cycle_MD]"] \
                     "[_ lorsm.Edit_Contributor]"]
    set title "[_ lorsm.lt_Edit_Lifecycle_MD_Con]"
} else {
    set context [list \
                     [list   [export_vars -base ".." ims_md_id] \
                          "[_ lorsm.IMS_Metadata_Editor]"] \
                     [list   [export_vars -base "../lifecyclemd" ims_md_id] \
                          "[_ lorsm.Life_Cycle_MD]"] \
                     "[_ lorsm.Add_Contributor]"]
    set title "[_ lorsm.lt_Add_Lifecycle_MD_Cont]"
}

# Form
ad_form \
    -name lifecyclemd_cont \
    -cancel_url ../lifecyclemd?ims_md_id=$ims_md_id \
    -mode edit \
    -select_query_name lifecyclemd_cont_ad_form \
    -form {
        ims_md_lf_cont_id:key(ims_md_life_cycle_contrib_seq)

        {role_s:text,nospell
            {html {size 10}}
            {help_text "[_ lorsm.lt_Source_of_vocabulary_]"}
            {label "[_ lorsm.Source]"}
        }

        {role_v:text,nospell
            {html {size 10}}
            {help_text "[_ lorsm.Type_of_contribution]"}
            {label "[_ lorsm.Role_1]"}
        }

        {entity:text(textarea),nospell
            {html {rows 5 cols 50}}
            {help_text "[_ lorsm.lt_Entity_or_entities_in]"}
            {label "[_ lorsm.Entity]"}
        }

        {cont_date:text,nospell
            {html {size 10}}
            {help_text "[_ lorsm.Date_of_contribution]"}
            {label "[_ lorsm.Date]"}
        }

        {cont_date_l:text,nospell,optional
            {html {size 10}}
            {help_text "[_ lorsm.lt_ie_en_AU_for_Australi_3]"}
            {label "[_ lorsm.Language]"}
        }

        {cont_date_s:text(textarea),nospell,optional
            {html {rows 2 cols 50}}
            {help_text "[_ lorsm.lt_Describes_contributio]"}
            {label "[_ lorsm.Description]"}
        }

        {ims_md_id:text(hidden) {value $ims_md_id}}

    } -edit_data {
        db_transaction {
            db_dml update_lfc {}

            db_dml update_lfce {}
        }

    } -new_data {
        db_transaction {
            db_dml insert_lfc {}

            db_dml insert_lfce {}
        }

    } -after_submit {
        ad_returnredirect [export_vars -base "../lifecyclemd" {ims_md_id}]
        ad_script_abort
    }

# Lifecycle Contrib
template::list::create \
    -name d_lf_cont \
    -multirow d_lf_cont \
    -no_data "[_ lorsm.lt_No_Contributors_Avail]" \
    -html { align right style "width: 100%;" } \
    -elements {
        role { label "[_ lorsm.Role]" }
        entity { label "[_ lorsm.Entity_1]" }
        cont_date { label "[_ lorsm.Contribution_Date]" }
        cont_date_ls { label "[_ lorsm.Description_1]" }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars \
                                -base "lifecycle_cont" \
                                {ims_md_lf_cont_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record] "}
            html { align center }
        }
    }

db_multirow d_lf_cont select_lf_cont {}

