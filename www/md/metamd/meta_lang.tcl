# packages/lorsm/www/md/metamd/meta_lang.tcl

ad_page_contract {
    
    Add/Edit Meta MD Language
    
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
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../metamd" im\s_\\\md_id] "Meta Metadata"] "Edit Language"]
set title "Edit Meta MD Language"

# Form

ad_form -name metamd_lang \
    -cancel_url ../metamd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {language:text,nospell
	{section "Add/Edit Meta MD Language"}
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the mdmd language details already exist...

    if {[db_0or1row select_lang {select ims_md_id from ims_md_metadata where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_metadata
            set language = :language
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_metadata (ims_md_id, language)
            values
            (:ims_md_id, :language)"

    }

} -after_submit {
    ad_returnredirect [export_vars -base "../metamd" {ims_md_id}]
        ad_script_abort
} 

# Metametadata Language
template::list::create \
    -name d_md_lang \
    -multirow d_md_lang \
    -no_data "No Language Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        language {
            label "Language"
        }
    }

db_multirow d_md_lang select_md_lang {
    select language, 
           ims_md_id
    from 
           ims_md_metadata
    where
           ims_md_id = :ims_md_id
} 
