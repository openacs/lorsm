# packages/lorsm/www/md/metamd/meta_cont.tcl

ad_page_contract {
    
    Add/Edit Meta MD Contributor
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_md_cont_id:integer,optional
    ims_md_md_cont_enti_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_md_cont_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../metamd" im\s_\md_id] "Meta Metadata"] "Add Contributor"]
    set title "Edit Meta MD Contributor"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../metamd" im\s_\md_id] "Meta Metadata"] "Add Contributor"]
    set title "Add Meta MD Contributor"
}

# Form

ad_form -name metamd_cont \
    -cancel_url ../metamd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_md_cont_id:key(ims_md_metadata_contrib_seq)

    {role_s:text,nospell
	{section "Add/Edit Meta MD Contributor"}
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }

    {role_v:text,nospell
        {html {size 10}}
	{help_text "Type of contribution"}
        {label "Role:"}
    }
    
    {entity:text(textarea),nospell
        {html {rows 5 cols 50}}
	{help_text "Entity or entities involved"}
        {label "Entity:"}
    }

    {cont_date:text,nospell
        {html {size 10}}
	{help_text "Date of contribution"}
        {label "Date:"}
    }

    {cont_date_l:text,nospell,optional
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English (Required if entering Description)"}
        {label "Language:"}
    }

    {cont_date_s:text(textarea),nospell,optional
        {html {rows 2 cols 50}}
	{help_text "Describes contribution"}
        {label "Description:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {
     select * from 
        ims_md_metadata_contrib mdc, 
        ims_md_metadata_contrib_entity mdce 
    where
        mdc.ims_md_md_cont_id = :ims_md_md_cont_id
    and
        mdc.ims_md_id = :ims_md_id
    and
        mdce.ims_md_md_cont_id = :ims_md_md_cont_id

} -edit_data {
    db_transaction {
	    db_dml update_mdc "
            update ims_md_metadata_contrib
            set role_v = :role_v, 
            role_s = :role_s, 
            cont_date = :cont_date, 
            cont_date_l = :cont_date_l, 
            cont_date_s = :cont_date_s
            where ims_md_md_cont_id = :ims_md_md_cont_id"
            
            db_dml update_mdce "
            update ims_md_metadata_contrib_entity
            set entity = :entity
            where ims_md_md_cont_id = :ims_md_md_cont_id"
    }
         
} -new_data {
    db_transaction {
	    db_dml insert_mdc "
            insert into ims_md_metadata_contrib (ims_md_md_cont_id, ims_md_id, role_s, role_v, cont_date, cont_date_l, cont_date_s)
            values (:ims_md_md_cont_id, :ims_md_id, :role_s, :role_v, :cont_date, :cont_date_l, :cont_date_s)"

	    db_dml insert_mdce "
            insert into ims_md_metadata_contrib_entity (ims_md_md_cont_enti_id, ims_md_md_cont_id, entity)
            values (nextval('ims_md_metadata_contrib_entity_seq'), :ims_md_md_cont_id, :entity)"
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../metamd" {ims_md_id}]
        ad_script_abort
} 

# Metametadata Contrib
template::list::create \
    -name d_md_cont \
    -multirow d_md_cont \
    -no_data "No Contributors Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        role {
            label "Role"
        }
        entity {
            label "Entity"
        }
	cont_date {
	    label "Contribution Date"
	}
	cont_date_ls {
	    label "Description"
	}
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "meta_cont" {ims_md_md_cont_id ims_md_id}] }
            link_html {title "Edit Record "}
            html { align center }
        }
    }

db_multirow d_md_cont select_md_cont {
    select
        mdc.role_v || ' ' || '[' || mdc.role_s || ']' as role,
        mdce.entity,
        mdc.cont_date,
        '[' || mdc.cont_date_l || ']' || ' ' || mdc.cont_date_s as cont_date_ls,
        mdc.ims_md_md_cont_id,
        mdc.ims_md_id
    from 
        ims_md_metadata_contrib mdc, 
        ims_md_metadata_contrib_entity mdce 
    where
        mdc.ims_md_md_cont_id = mdce.ims_md_md_cont_id
    and
        mdc.ims_md_id = :ims_md_id
}

