# packages/lorsm/www/md/educationalmd/educational_ieur.tcl

ad_page_contract {
    
    Add/Edit Educational MD Intended End User Role
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ed_ie_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ed_ie_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" ims_md_id] "Educational MD"] "Edit Intended End User Role"]
    set title "Edit Educational MD Intended End User Role"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" ims_md_id] "Educational MD"] "Add Intended End User Role"]
    set title "Add Educational MD Intended End User Role"
}

# Form

ad_form -name educationalmd_ieur \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ed_ie_id:key(ims_md_educational_ieur_seq)

    {ieur_s:text,nospell
	{section "Add/Edit Educational MD Intended End User Role"}
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }

    {ieur_v:text,nospell
        {html {size 10}}
	{help_text "Normal user of the learning object"}
        {label "Intended End User Role:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_educational_ieur where ims_md_ed_ie_id = :ims_md_ed_ie_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_educational_ieur
            set ieur_s = :ieur_s,
            ieur_v = :ieur_v
            where ims_md_ed_ie_id = :ims_md_ed_ie_id"
} -new_data {
       db_dml do_insert "
            insert into ims_md_educational_ieur (ims_md_ed_ie_id, ims_md_id, ieur_s, ieur_v) 
            values (:ims_md_ed_ie_id, :ims_md_id, :ieur_s, :ieur_v)"
} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Intended End User Role
template::list::create \
    -name d_ed_ieur \
    -multirow d_ed_ieur \
    -no_data "No Intended End User Role Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	ieur {
            label "Intended End User Role"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "educational_ieur" {ims_md_ed_ie_id ims_md_id}] }
            link_html {title "Edit Record"}
            html { align center }
        }
    }

db_multirow d_ed_ieur select_ed_ieur {
    select 
        '[' || ieur_s || '] ' || ieur_v as ieur,
        ims_md_ed_ie_id,
        ims_md_id
    from 
           ims_md_educational_ieur
    where
           ims_md_id = :ims_md_id
} 
