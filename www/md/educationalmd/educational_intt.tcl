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
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" ims_md_id] "Educational MD"] "Add/Edit Interactivity Type"]
set title "Add/Edit Educational MD Interactivity Type"

# Form

ad_form -name educationalmd_intt \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {int_type_s:text,nospell
	{section "Add/Edit Educational MD Interactivity Type"}
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }

    {int_type_v:text,nospell
        {html {size 10}}
	{help_text "Type of interactivity supported by the resource"}
        {label "Interactivity Type:"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the ED interactivity type details already exist...

    if {[db_0or1row select_type {select ims_md_id from ims_md_educational where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_educational
            set int_type_s = :int_type_s, int_type_v = :int_type_v
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_educational (ims_md_id, int_type_s, int_type_v)
            values
            (:ims_md_id, :int_type_s, :int_type_v) "
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Interactivity Type
template::list::create \
    -name d_ed_intt \
    -multirow d_ed_intt \
    -no_data "No Interactivity Type Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	intt {
            label "Interactivity Type"
        }
    }

db_multirow d_ed_intt select_ed_intt {
    select 
        '[' || int_type_s || '] ' || int_type_v as intt,
        ims_md_id
    from 
           ims_md_educational
    where
           ims_md_id = :ims_md_id
} 
