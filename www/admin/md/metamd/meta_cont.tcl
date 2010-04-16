# packages/lorsm/www/md/metamd/meta_cont.tcl

ad_page_contract {

    Add/Edit Meta MD Contributor

    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_md_cont_id:integer,optional
    ims_md_md_cont_enti_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_md_cont_id]} {
    set context [list \
                     [list   [export_vars -base ".." ims_md_id] \
                          "[_ lorsm.IMS_Metadata_Editor]"] \
                     [list   [export_vars -base "../metamd" ims_\md_id] \
                          "[_ lorsm.Meta_Metadata]"] \
                     "[_ lorsm.Add_Contributor]"]
    set title "[_ lorsm.lt_Edit_Meta_MD_Contribu]"
} else {
    set context [list \
                     [list   [export_vars -base ".." ims_md_id] \
                          "[_ lorsm.IMS_Metadata_Editor]"] \
                     [list   [export_vars -base "../metamd" ims_\md_id] \
                          "[_ lorsm.Meta_Metadata]"] \
                     "[_ lorsm.Add_Contributor]"]
    set title "[_ lorsm.lt_Add_Meta_MD_Contribut]"
}

# Form

ad_form \
    -name metamd_cont \
    -cancel_url ../metamd?ims_md_id=$ims_md_id \
    -mode edit \
    -select_query_name metamd_cont_ad_form \
    -form {
        ims_md_md_cont_id:key(ims_md_metadata_contrib_seq)

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
            db_dml update_mdc {}

            db_dml update_mdce {}
        }

    } -new_data {
        db_transaction {
            db_dml insert_mdc {}

            db_dml insert_mdce {}
        }

    } -after_submit {
        ad_returnredirect [export_vars -base "../metamd" {ims_md_id}]
        ad_script_abort
    }

# Metametadata Contrib
template::list::create \
    -name d_md_cont \
    -multirow d_md_cont \
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
                                -base "meta_cont" \
                                {ims_md_md_cont_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record] "}
            html { align center }
        }
    }

db_multirow d_md_cont select_md_cont {}
