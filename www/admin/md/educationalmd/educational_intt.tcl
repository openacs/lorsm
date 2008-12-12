# packages/lorsm/www/md/educationalmd/educational_intt.tcl

ad_page_contract {

    Add/Edit Educational MD Interactivity Type

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

                [list   [export_vars -base "../educationalmd" ims_md_id] \
                        "[_ lorsm.Educational_MD]"] \

                "[_ lorsm.lt_AddEdit_Interactivity]"]
set title "[_ lorsm.lt_AddEdit_Educational_M_16]"

# Form
ad_form \
    -name educationalmd_intt \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {
        {int_type_s:text,nospell
            {html {size 10}}
            {help_text "[_ lorsm.lt_Source_of_vocabulary_]"}
            {label "[_ lorsm.Source]"}
        }

        {int_type_v:text,nospell
            {html {size 10}}
            {help_text "[_ lorsm.lt_Type_of_interactivity]"}
            {label "[_ lorsm.Interactivity_Type]"}
        }

        {ims_md_id:text(hidden) {value $ims_md_id}}

    } -on_submit {
        # check if the ED interactivity type details already exist...

        if {[db_0or1row select_type {}]} {
            db_dml do_update {}
        } else {
            db_dml do_insert {}
        }

    } -after_submit {
        ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
    }

# Educational Interactivity Type
template::list::create \
    -name d_ed_intt \
    -multirow d_ed_intt \
    -no_data "[_ lorsm.lt_No_Interactivity_Type]" \
    -html { align right style "width: 100%;" } \
    -elements {
        intt { label "[_ lorsm.Interactivity_Type_1]" }
    }

db_multirow d_ed_intt select_ed_intt {}
