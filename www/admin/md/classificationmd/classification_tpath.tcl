ad_page_contract {
    Displays IMS Metadata Classification Taxonomic Path Entry

    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_cl_id:integer
    ims_md_cl_ta_id:integer
    ims_md_id:integer
}

# set context & title
set context [list \
                [list   [export_vars -base ".." ims_md_id] \
                        "[_ lorsm.IMS_Metadata_Editor]"] \

                [list   [export_vars -base "../classificationmd" ims_md_id] \
                        "[_ lorsm.Classification_MD]"] \

                [list   [export_vars -base "classification" \
                            {ims_md_id ims_md_cl_id ims_md_cl_ta_id}] \
                        "[_ lorsm.Classification_Entry]"] \

                "[_ lorsm.Taxonomic_Paths_1]"]

set title "[_ lorsm.lt_Classification_MD_Tax]"

# Classification Taxonomic Path Source
template::list::create \
    -name d_cl_source \
    -multirow d_cl_source \
    -no_data "[_ lorsm.No_Source_Available]" \
    -actions [list \
                "[_ lorsm.Add_Source]" \
                [export_vars \
                    -base classification_tsource \
                    {ims_md_cl_ta_id ims_md_cl_id ims_md_id}] \
                "[_ lorsm.Add_another_Source]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        source { label "" }
    }

db_multirow d_cl_source select_cl_source {}

# Classification Taxonomic Path Taxonomy
template::list::create \
    -name d_cl_taxon \
    -multirow d_cl_taxon \
    -no_data "[_ lorsm.lt_No_Taxonomies_Availab]" \
    -actions [list \
                "[_ lorsm.Add_Taxonomy]" \
                [export_vars \
                    -base classification_taxon \
                    {ims_md_cl_ta_id ims_md_cl_id ims_md_id}] \
                "[_ lorsm.Add_another_Taxonomy]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        identifier { label "[_ lorsm.ID]" }
        entry { label "[_ lorsm.Entry_1]" }
    }

db_multirow d_cl_taxon select_cl_taxon {}
