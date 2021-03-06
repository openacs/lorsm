# packages/lorsm/www/md/educationalmd/educational_tlt.tcl

ad_page_contract {

    Add/Edit Educational MD Typical Learning Time

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
                      "[_ lorsm.IMS_Metadata_Editor]"]  \
                 [list   [export_vars -base "../educationalmd" ims_md_id] \
                      "[_ lorsm.Educational_MD]"] \
                 "[_ lorsm.lt_AddEdit_Typical_Learn]"]
set title "[_ lorsm.lt_Edit_Educational_MD_T_1]"

# Form
ad_form \
    -name educationalmd_tlt \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {
        {type_lrn_time_l:text,nospell,optional
            {html {size 10}}
            {help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
            {label "[_ lorsm.Language]"}
        }

        {type_lrn_time_s:text(textarea),nospell,optional
            {html {rows 2 cols 50}}
            {help_text "[_ lorsm.lt_Brief_Description_Req]"}
            {label "[_ lorsm.Description]"}
        }

        {type_lrn_time:text,nospell
            {html {size 20}}
            {help_text "[_ lorsm.lt_Amount_of_time_it_tak]"}
            {label "[_ lorsm.lt_Typical_Learning_Time]"}
        }

        {ims_md_id:text(hidden) {value $ims_md_id}}

    } -on_submit {
        # check if the educational typical learning time details already exist...

        if {[db_0or1row select_size {}]} {
            db_dml do_update {}
        } else {
            db_dml do_insert {}
        }

    } -after_submit {
        ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
}

# Educational Typical Learning Time
template::list::create \
    -name d_ed_tlt \
    -multirow d_ed_tlt \
    -no_data "[_ lorsm.lt_No_Typical_Learning_T]" \
    -html { align right style "width: 100%;" } \
    -elements {
        tlt { label "[_ lorsm.lt_Typical_Learning_Time_1]" }
        tlt_ls { label "[_ lorsm.Language_1]" }
    }

db_multirow d_ed_tlt select_ed_tlt {}
