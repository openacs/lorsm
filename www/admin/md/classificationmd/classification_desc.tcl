# packages/lorsm/www/md/classificationmd/classification_desc.tcl

ad_page_contract {

    Add/Edit Classification MD Description

    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_cl_id:integer
    ims_md_cl_de_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_cl_de_id]} {
    set context [list \
                     [list [export_vars -base "../" ims_md_id] [_ lorsm.IMS_Metadata_Editor]] \
                     [list [export_vars -base "../classificationmd" ims_md_id] [_ lorsm.Classification_MD]] \
                     [list [export_vars -base "classification" {ims_md_id ims_md_cl_id}] [_ lorsm.Classification_Entry]] \
                     [_ lorsm.Edit_Description]]

    set title "[_ lorsm.lt_Edit_Classification_M_4]"
} else {
    set context [list \
                     [list   [export_vars -base ".." ims_md_id] [_ lorsm.IMS_Metadata_Editor]] \
                     [list   [export_vars -base "../classificationmd" ims_md_id] [_ lorsm.Classification_MD]] \
                     [list   [export_vars -base "classification" {ims_md_id ims_md_cl_id}] [_ lorsm.Classification_Entry]] \
                     [_ lorsm.Add_Description]]
    
    set title "[_ lorsm.lt_Add_Classification_MD_2]"
}

# Form

ad_form \
    -name classificationmd_desc \
    -cancel_url classification?ims_md_id=$ims_md_id&ims_md_cl_id=$ims_md_cl_id \
    -mode edit \
    -select_query_name classificationmd_desc_ad_form \
    -form {
        ims_md_cl_de_id:key(ims_md_classification_desc_seq)

        {descrip_l:text,nospell
            {html {size 10}}
            {help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
            {label "[_ lorsm.Language]"}
        }

        {descrip_s:text(textarea),nospell
            {html {rows 2 cols 50}}
            {help_text "[_ lorsm.lt_Description_of_the_le]"}
            {label "[_ lorsm.Description]"}
        }

        {ims_md_id:text(hidden) {value $ims_md_id}}

        {ims_md_cl_id:text(hidden) {value $ims_md_cl_id}}

    } -edit_data {
        db_dml do_update {}

    } -new_data {
        db_dml do_insert {}

    } -after_submit {
        ad_returnredirect [export_vars -base "classification" {ims_md_cl_id ims_md_id}]
        ad_script_abort
    }

# Classification Description
template::list::create \
    -name d_cl_desc \
    -multirow d_cl_desc \
    -no_data "[_ lorsm.lt_No_Description_Availa]" \
    -html { align right style "width: 100%;" } \
    -elements {
        desc { label "" }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "classification_desc" {ims_md_cl_de_id ims_md_cl_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_cl_desc select_cl_desc {}
