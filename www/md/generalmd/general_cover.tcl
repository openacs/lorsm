# packages/lorsm/www/md/generalmd/general_cover.tcl

ad_page_contract {
    
    Add/Edit General MD Coverage
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ge_cove_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ge_cove_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../generalmd" im\\\s_md_id] "General MD"] "Edit Coverage"]
    set title "Edit General MD Coverage"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../generalmd" im\\\s_md_id] "General MD"] "Add Coverage"]
    set title "Add General MD Coverage"
}

# Form

ad_form -name generalmd_cover \
    -cancel_url ../generalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ge_cove_id:key(ims_md_general_cover_seq)

    {cover_l:text,nospell,optional
	{section "Add/Edit General MD Coverage"}
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }
    
    {cover_s:text,nospell
        {html {size 50}}
	{help_text "Temporal/spatial characteristics of content"}
        {label "Coverage:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_general_cover where ims_md_ge_cove_id = :ims_md_ge_cove_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_general_cover
            set cover_l = :cover_l, cover_s = :cover_s
            where ims_md_ge_cove_id = :ims_md_ge_cove_id "
} -new_data {
        db_dml do_insert "
            insert into ims_md_general_cover (ims_md_ge_cove_id, ims_md_id, cover_l, cover_s)
            values
            (:ims_md_ge_cove_id, :ims_md_id, :cover_l, :cover_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "../generalmd" {ims_md_id}]
        ad_script_abort
} 

# General Coverage
template::list::create \
    -name d_gen_cover \
    -multirow d_gen_cover \
    -no_data "No Coverage Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        cover_l {
            label "Language"
        }
        cover_s {
            label "Coverage"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "general_cover" {ims_md_ge_cove_id ims_md_id}] }
            link_html {title "Edit Record "}
            html { align center }
        }
    }

db_multirow d_gen_cover select_ge_cover {
    select cover_l,
           cover_s, 
           ims_md_ge_cove_id,
           ims_md_id
    from 
           ims_md_general_cover
    where
           ims_md_id = :ims_md_id
}
