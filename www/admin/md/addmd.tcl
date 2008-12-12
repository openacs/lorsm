# packages/lorsm/www/md/addmd.tcl

ad_page_contract {

    Add metadata schema

    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-11-13
    @arch-tag: 28b76527-a05f-42cf-b562-37c7b85e799f
    @cvs-id $Id$
} {
    ims_md_id:integer
} -properties {
} -validate {
} -errors {
}

# Get object information
set object_type [acs_object_type $ims_md_id]

# set context & title
set context [list \
                [list   [export_vars -base "." ims_md_id] \
                "[_ lorsm.IMS_Metadata_Editor]"] \
            "[_ lorsm.lt_Edit_Metadata_Schema_]"]

set title "[_ lorsm.lt_AddEdit_MD_Schema_and]"


# Form
ad_form -name add_md \
    -cancel_url ".." \
    -mode edit \
    -form {
        {schema:text,nospell
            {html {size 20}}
            {help_text "[_ lorsm.lt_Metadata_schema_ie_IM]"}
            {label "[_ lorsm.Schema]"}
        }

        {schemaversion:text,nospell
            {html {size 10}}
            {help_text "[_ lorsm.lt_Version_of_the_Schema]"}
            {label "[_ lorsm.Schema_Version]"}
        }

        {ims_md_id:text(hidden) {value $ims_md_id}}

    } -on_submit {
        db_transaction {
            if {![lors::imsmd::mdExist -ims_md_id $ims_md_id]} {
                db_dml do_insert {}
            } else {
                db_dml do_update {}
            }

            # If the object_type is on any of the IMS CP object types,
            # then we update also the ims cp tables accordingly.

            switch $object_type {
                "ims_manifest_object" {
                    db_dml upd_manifest {}

                } "ims_item_object" {
                    db_dml upd_item {}

                } "ims_organization_object" {
                    db_dml upd_organization {}

                } "ims_resource_object" {
                    db_dml upd_resource {}

                } "content_item" {
                    db_dml upd_file {}
                }
            }
        }

    } -after_submit {
        ad_returnredirect [export_vars -base "." ims_md_id]
        ad_script_abort
    }

# MD Schema Info
template::list::create \
    -name md_schema_info \
    -multirow md_schema_info \
    -no_data "[_ lorsm.No_Schema_Available]" \
    -html { align right style "width: 100%;" } \
    -elements {
        schema {
            label "[_ lorsm.Schema_1]"
            html { align center }

        } schemaversion {
            label "[_ lorsm.Version_1]"
            html { align center }
        }
    }

db_multirow md_schema_info select_md_schema {}
