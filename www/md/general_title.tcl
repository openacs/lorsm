# packages/lorsm/www/md/general_title.tcl

ad_page_contract {
    
    Add/Edit General MD Title
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-05-03
    @arch-tag 1956d02e-511a-470c-81d0-c2857242651c
    @cvs-id $Id$
} {
    ims_md_id:integer
    ims_md_ge_ti_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ge_ti_id]} {
    set context [list "IMS Metadata Editor - General MD"]
    set title "Edit General MD Title"
} else {
    set context [list "IMS Metadata Editor - General MD"]
    set title "Add General MD Title"
}

# Form

ad_form -name generalmd_title \
    -cancel_url index \
    -mode edit \
    -form {

    ims_md_ge_ti_id:key(ims_md_general_title_seq)

    {title_l:text,nospell,optional
	{section "Add/Edit General MD Title"}
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }
    
    {title_s:text,nospell
        {html {size 50}}
        {label "Title:"}
    }

    {ims_md_id:text(hidden)
    }

} -select_query  {select * from ims_md_general_title where ims_md_ge_ti_id = :ims_md_ge_ti_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_general_title
            set title_l = :title_l, title_s = :title_s
            where ims_md_ge_ti_id = :ims_md_ge_ti_id "
} -new_data {
        db_dml do_insert "
            insert into ims_md_general_title (ims_md_ge_ti_id, ims_md_id, title_l, title_s)
            values
            (:ims_md_ge_ti_id, :ims_md_id, :title_l, :title_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "general_title" {ims_md_id}]
        ad_script_abort
} 

# General Title
template::list::create \
    -name d_gen_titles \
    -multirow d_gen_titles \
    -no_data "No Titles Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        title_l {
            label ""
        }
        title_s {
            label ""
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "general_title" {ims_md_ge_ti_id ims_md_id}] }
            link_html {title "Edit Record "}
            html { align center }
        }
    }

db_multirow d_gen_titles select_ge_titles {
    select title_l,
           title_s, 
           ims_md_ge_ti_id,
           ims_md_id
    from 
           ims_md_general_title
    where
           ims_md_id = :ims_md_id
} {
    set item_url [export_vars -base "item" { ims_md_id }]
}

