# packages/lorsm/www/md/educationalmd/educational_lang.tcl

ad_page_contract {
    
    Add/Edit Educational MD Language
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ed_la_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ed_la_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" ims_md_id] "Educational MD"] "Edit Language"]
    set title "Edit Educational MD Language"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" ims_md_id] "Educational MD"] "Add Language"]
    set title "Add Educational MD Language"
}

# Form

ad_form -name educationalmd_lang \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ed_la_id:key(ims_md_educational_lang_seq)

    {language:text,nospell
	{section "Add/Edit Educational MD Language"}
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_educational_lang where ims_md_ed_la_id = :ims_md_ed_la_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_educational_lang
            set language = :language
            where ims_md_ed_la_id = :ims_md_ed_la_id "
} -new_data {
       db_dml do_insert "
            insert into ims_md_educational_lang (ims_md_ed_la_id, ims_md_id, language) 
            values (:ims_md_ed_la_id, :ims_md_id, :language)"
} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Language
template::list::create \
    -name d_ed_lang \
    -multirow d_ed_lang \
    -no_data "No Language Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	language {
            label "Language"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "educational_lang" {ims_md_ed_la_id ims_md_id}] }
            link_html {title "Edit Record"}
            html { align center }
        }
    }

db_multirow d_ed_lang select_ed_lang {
    select 
        language,
        ims_md_ed_la_id,
        ims_md_id
    from 
           ims_md_educational_lang
    where
           ims_md_id = :ims_md_id
} 
