# packages/lorsm/www/md/generalmd/general_aggl.tcl

ad_page_contract {
    
    Add/Edit General MD Aggregation Level
    
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
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../generalmd" im\\\\\s_md_id] "General MD"] "Edit Aggregation Level"]
set title "Edit General MD Aggregation Level"

# Form

ad_form -name generalmd_aggl \
    -cancel_url ../generalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {



    {agg_level_v:text,nospell
	{section "Add/Edit General MD Aggregation Level"}
        {html {size 10}}
	{help_text "Functional size of the resource"}
        {label "Aggregation Level:"}
    }
    
    {agg_level_s:text,nospell,optional
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }
    
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the aggregation level already exist..

    if {[db_0or1row select_aggregation_level {select ims_md_id from ims_md_general where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_general
            set agg_level_v = :agg_level_v, agg_level_s = :agg_level_s
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_general (ims_md_id, agg_level_v, agg_level_s)
            values
            (:ims_md_id, :agg_level_v, :agg_level_s)"

    }

} -after_submit {
    ad_returnredirect [export_vars -base "../generalmd" {ims_md_id}]
        ad_script_abort
} 

# General Aggregation Level
template::list::create \
    -name d_gen_aggl \
    -multirow d_gen_aggl \
    -no_data "No Aggregation Level Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        agg_level_s {
            label "Source"
        }
        agg_level_v {
            label "Value"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "general_aggl" {ims_md_id}] }
            link_html {title "Edit Record "}
            html { align center }
        }
    }

db_multirow d_gen_aggl select_ge_aggl {
    select agg_level_s,
           agg_level_v, 
           ims_md_id
    from 
           ims_md_general
    where
           ims_md_id = :ims_md_id
}

