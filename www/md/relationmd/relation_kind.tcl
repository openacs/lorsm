# packages/lorsm/www/md/relationmd/relation_kind.tcl

ad_page_contract {
    
    Add/Edit Relation MD Kind
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_re_id:integer
    ims_md_re_re_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title

set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../relationmd" ims_md_id] "Relation MD"] [list [export_vars -base "relation" {ims_md_id ims_md_re_id ims_md_re_re_id}] "Relation Entry"] "Add/Edit Kind"]
set title "Add/Edit Relation MD Kind"

# Form

ad_form -name relationmd_kind \
    -cancel_url relation?ims_md_id=$ims_md_id&ims_md_re_id=$ims_md_re_id&ims_md_re_re_id=$ims_md_re_re_id \
    -mode edit \
    -form {

    ims_md_re_id:key(ims_md_relation_seq)

    {kind_s:text,nospell
	{section "Add/Edit Relation MD Kind"}
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }
    
    {kind_v:text,nospell
        {html {size 20}}
	{help_text "Nature of the relationship between the resource being described and the one identified by Resource"}
        {label "Kind:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    } 
    
    {ims_md_re_re_id:text(hidden) {value $ims_md_re_re_id}
    }

} -select_query  {select * from ims_md_relation where ims_md_re_id = :ims_md_re_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_relation
            set kind_s = :kind_s,
            kind_v = :kind_v
            where ims_md_re_id = :ims_md_re_id"

} -after_submit {
    ad_returnredirect [export_vars -base "relation" {ims_md_re_re_id ims_md_re_id ims_md_id}]
        ad_script_abort
} 

# Relation Kind
template::list::create \
    -name d_re_kind \
    -multirow d_re_kind \
    -no_data "No Kind Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	kind_s {
            label "Source"
        }
	kind_v {
	    label "Value"
	}
    }

db_multirow d_re_kind select_re_kind {
   select  re.kind_s,
           re.kind_v,
           re.ims_md_re_id,
           re.ims_md_id,
           rere.ims_md_re_re_id
    from 
           ims_md_relation re,
           ims_md_relation_resource rere
    where
           re.ims_md_re_id = :ims_md_re_id
    and    rere.ims_md_re_id = :ims_md_re_id
} 
