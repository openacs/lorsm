# packages/lorsm/www/md/lifecyclemd/lifecycle_cont.tcl

ad_page_contract {
    
    Add/Edit Lifecycle MD Contributor
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_lf_cont_id:integer,optional
    ims_md_lf_cont_enti_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_lf_cont_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../lifecyclemd" im\\\\\\\s_md_id] "Life Cycle MD"] "Edit Contributor"]
    set title "Edit Lifecycle MD Contributor"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../lifecyclemd" im\\\\\\\s_md_id] "Life Cycle MD"] "Add Contributor"]
    set title "Add Lifecycle MD Contributor"
}

# Form

ad_form -name lifecyclemd_cont \
    -cancel_url ../lifecyclemd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_lf_cont_id:key(ims_md_life_cycle_contrib_seq)

    {role_s:text,nospell
	{section "Add/Edit Lifecycle MD Contributor"}
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
        ims_md_life_cycle_contrib lfc, 
        ims_md_life_cycle_contrib_entity lfce 
    where
        lfc.ims_md_lf_cont_id = :ims_md_lf_cont_id
    and
        lfc.ims_md_id = :ims_md_id
    and
        lfce.ims_md_lf_cont_id = :ims_md_lf_cont_id

} -edit_data {
    db_transaction {
	    db_dml update_lfc "
            update ims_md_life_cycle_contrib
            set role_v = :role_v, 
            role_s = :role_s, 
            cont_date = :cont_date, 
            cont_date_l = :cont_date_l, 
            cont_date_s = :cont_date_s
            where ims_md_lf_cont_id = :ims_md_lf_cont_id"
            
            db_dml update_lfce "
            update ims_md_life_cycle_contrib_entity
            set entity = :entity
            where ims_md_lf_cont_id = :ims_md_lf_cont_id"
    }
         
} -new_data {
    db_transaction {
	    db_dml insert_lfc "
            insert into ims_md_life_cycle_contrib (ims_md_lf_cont_id, ims_md_id, role_s, role_v, cont_date, cont_date_l, cont_date_s)
            values (:ims_md_lf_cont_id, :ims_md_id, :role_s, :role_v, :cont_date, :cont_date_l, :cont_date_s)"

	    db_dml insert_lfce "
            insert into ims_md_life_cycle_contrib_entity (ims_md_lf_cont_enti_id, ims_md_lf_cont_id, entity)
            values (nextval('ims_md_life_cycle_contrib_entity_seq'), :ims_md_lf_cont_id, :entity)"
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../lifecyclemd" {ims_md_id}]
        ad_script_abort
} 

# Lifecycle Contrib
template::list::create \
    -name d_lf_cont \
    -multirow d_lf_cont \
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
            link_url_eval { [export_vars -base "lifecycle_cont" {ims_md_lf_cont_id ims_md_id}] }
            link_html {title "Edit Record "}
            html { align center }
        }
    }

db_multirow d_lf_cont select_lf_cont {
    select
        lfc.role_v || ' ' || '[' || lfc.role_s || ']' as role,
        lfce.entity,
        lfc.cont_date,
        '[' || lfc.cont_date_l || ']' || ' ' || lfc.cont_date_s as cont_date_ls,
        lfc.ims_md_lf_cont_id,
        lfc.ims_md_id
    from 
        ims_md_life_cycle_contrib lfc, 
        ims_md_life_cycle_contrib_entity lfce 
    where
        lfc.ims_md_lf_cont_id = lfce.ims_md_lf_cont_id
    and
        lfc.ims_md_id = :ims_md_id
}

