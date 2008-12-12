ad_page_contract {
    Displays/Adds IMS Metadata Metametadata

    @author Ernie Ghiglione (ErnieG@ee.usyd.edu.au)
    @creation-date 30 January 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list \
                [list   [export_vars -base "." ims_md_id] \
                        "[_ lorsm.IMS_Metadata_Editor]"] \
                        "[_ lorsm.Meta_Metadata]"]
set title "[_ lorsm.Meta_MD]"

# Metametadata Catalogentry
template::list::create \
    -name d_md_cata \
    -multirow d_md_cata \
    -no_data "[_ lorsm.lt_No_Catalog_Entry_Avai]" \
    -actions [list  "[_ lorsm.Add_Catalog-Entry]" \
                    [export_vars -base metamd/meta_cata {ims_md_id}] \
                    "[_ lorsm.lt_Add_another_Catalog-E]"] \

    -html { style "width: 100%; align: right;" } \
    -elements {
        catalog { label "[_ lorsm.Catalog_1]" }
        entry_ls { label "[_ lorsm.Language_Entry]" }
    }
db_multirow d_md_cata select_md_cata {}


# Metametadata Contrib
template::list::create \
    -name d_md_cont \
    -multirow d_md_cont \
    -no_data "[_ lorsm.lt_No_Contributors_Avail]" \
    -actions [list  "[_ lorsm.Add_Contributors]" \
                    [export_vars -base metamd/meta_cont {ims_md_id}] \
                    "[_ lorsm.lt_Add_another_Contribut]"] \

    -html { style "width: 100%; align:right; " } \
    -elements {
        role { label "[_ lorsm.Role]" }
        entity { label "[_ lorsm.Entity_1]" }
        cont_date { label "[_ lorsm.Contribution_Date]" }
        cont_date_ls { label "[_ lorsm.Description_1]" }
    }
db_multirow d_md_cont select_md_cont {}

# Metametadata metadatascheme
template::list::create \
    -name d_md_scheme \
    -multirow d_md_scheme \
    -no_data "[_ lorsm.No_Scheme_Available]" \
    -actions [list  "[_ lorsm.Add_Scheme]" \
                    [export_vars -base metamd/meta_scheme {ims_md_id}] \
                    "[_ lorsm.Add_another_Scheme]"] \
    -html { style "width: 100%; align:right;" } \
    -elements {
        scheme { label "" }
    }
db_multirow d_md_scheme select_md_scheme {}

# Metametadata language
template::list::create \
    -name d_md_lang \
    -multirow d_md_lang \
    -no_data "[_ lorsm.lt_No_Language_Available]" \
    -actions [list  "[_ lorsm.Add_Language]" \
                    [export_vars -base metamd/meta_lang {ims_md_id}] \
                    "[_ lorsm.lt_Add_another_Languages]"] \
    -html { style "width: 100%; align: right;" } \
    -elements {
        language { label "" }
    }
db_multirow d_md_lang select_md_lang {}
