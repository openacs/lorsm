# packages/lorsm/www/md/lifecyclemd/lifecycle_version.tcl

ad_page_contract {

    Add/Edit Lifecycle MD Version

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
                 [list   [export_vars -base "../lifecyclemd" ims_md_id] \
                      "[_ lorsm.Life_Cycle_MD]"] \
                 "[_ lorsm.Edit_Version]"]
set title "[_ lorsm.lt_Edit_Lifecycle_MD_Ver]"

# Form

ad_form \
    -name lifecyclemd_ver \
    -cancel_url ../lifecyclemd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {
        {version_l:text,nospell,optional
            {html {size 10}}
            {help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
            {label "[_ lorsm.Language]"}
        }

        {version_s:text,nospell
            {html {size 10}}
            {help_text "[_ lorsm.lt_Edition_of_the_learni]"}
            {label "[_ lorsm.Version]"}
        }

        {ims_md_id:text(hidden) {value $ims_md_id}}

    } -on_submit {
        # check if the LC version already exists...
        if {[db_0or1row select_lc_version {}]} {
            db_dml do_update {}
        } else {
            db_dml do_insert {}
        }

    } -after_submit {
        ad_returnredirect [export_vars -base "../lifecyclemd" {ims_md_id}]
        ad_script_abort
    }

# Lifecycle Version
template::list::create \
    -name d_lf_ver \
    -multirow d_lf_ver \
    -no_data "[_ lorsm.lt_No_Structure_Availabl]" \
    -html { align right style "width: 100%;" } \
    -elements {
        version_l { label "[_ lorsm.Language_1]" }
        version_s { label "[_ lorsm.Version_1]" }
    }

db_multirow d_lf_ver select_lf_ver {}
