# packages/lorsm/www/md/educationalmd/educational_lrt.tcl

ad_page_contract {
    
    Add/Edit Educational MD Learning Resource Type
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @creation-date 16 October 2004

} {
    ims_md_id:integer
    ims_md_ed_lr_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ed_lr_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" \i\m\\\s_md_id] "Educational MD"] "Edit Learning Resource Type"]
    set title "Edit Educational MD Learning Resource Type"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" \i\m\\\s_md_id] "Educational MD"] "Add Learning Resource Type"]
    set title "Add Educational MD Learning Resource Type"
}

# Form

ad_form -name educationalmd_lrt \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ed_lr_id:key(ims_md_educational_lrt_seq)

    {lrt_s:text,nospell
	{section "Add/Edit Educational MD Learning Resource Type"}
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }

    {lrt_v:text,nospell
        {html {size 10}}
	{help_text "Type of interactivity supported by the resource"}
        {label "Learning Resource Type:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_educational_lrt where ims_md_ed_lr_id = :ims_md_ed_lr_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_educational_lrt
            set lrt_s = :lrt_s,
            lrt_v = :lrt_v
            where ims_md_ed_lr_id = :ims_md_ed_lr_id "
} -new_data {
       db_dml do_insert "
            insert into ims_md_educational_lrt (ims_md_ed_lr_id, ims_md_id, lrt_s, lrt_v) 
            values (:ims_md_ed_lr_id, :ims_md_id, :lrt_s, :lrt_v)"
} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Learning Resource Type
template::list::create \
    -name d_ed_lrt \
    -multirow d_ed_lrt \
    -no_data "No Learning Resource Type Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	lrt {
            label ""
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "educational_lrt" {ims_md_ed_lr_id ims_md_id}] }
            link_html {title "Edit Record"}
            html { align center }
        }
    }

db_multirow d_ed_lrt select_ed_lrt {
    select 
        '[' || lrt_s || '] ' || lrt_v as lrt,
        ims_md_ed_lr_id,
        ims_md_id
    from 
           ims_md_educational_lrt
    where
           ims_md_id = :ims_md_id
} 
