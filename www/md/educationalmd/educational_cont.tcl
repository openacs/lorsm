# packages/lorsm/www/md/educationalmd/educational_cont.tcl

ad_page_contract {
    
    Add/Edit Educational MD Context
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ed_co_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ed_co_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" im\s_md_id] "Educational MD"] "Edit Context"]
    set title "Edit Educational MD Context"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" im\s_md_id] "Educational MD"] "Add Context"]
    set title "Add Educational MD Context"
}

# Form

ad_form -name educationalmd_cont \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ed_co_id:key(ims_md_educational_context_seq)

    {context_s:text,nospell
	{section "Add/Edit Educational MD Context"}
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }

    {context_v:text,nospell
        {html {size 20}}
	{help_text "Learning environment where use of learning object is intended to take place"}
        {label "Context:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_educational_context where ims_md_ed_co_id = :ims_md_ed_co_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_educational_context
            set context_s = :context_s,
            context_v = :context_v
            where ims_md_ed_co_id = :ims_md_ed_co_id "
} -new_data {
       db_dml do_insert "
            insert into ims_md_educational_context (ims_md_ed_co_id, ims_md_id, context_s, context_v) 
            values (:ims_md_ed_co_id, :ims_md_id, :context_s, :context_v)"
} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Context
template::list::create \
    -name d_ed_cont \
    -multirow d_ed_cont \
    -no_data "No Context Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	context {
            label "Context"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "educational_cont" {ims_md_ed_co_id ims_md_id}] }
            link_html {title "Edit Record"}
            html { align center }
        }
    }

db_multirow d_ed_cont select_ed_cont {
    select 
        '[' || context_s || '] ' || context_v as context,
        ims_md_ed_co_id,
        ims_md_id
    from 
           ims_md_educational_context
    where
           ims_md_id = :ims_md_id
} 
