# packages/lorsm/www/md/educationalmd/educational_dif.tcl

ad_page_contract {
    
    Add/Edit Educational MD Difficulty
    
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
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" ims_md_id] "Educational MD"] "Add/Edit Difficulty"]
set title "Add/Edit Educational MD Difficulty"

# Form

ad_form -name educationalmd_dif \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {difficulty_s:text,nospell
	{section "Add/Edit Educational MD Difficulty"}
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }

    {difficulty_v:text,nospell
        {html {size 10}}
	{help_text "Level of difficulty in working through the learning object"}
        {label "Difficulty:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the educational difficulty details already exist...

    if {[db_0or1row select_size {select ims_md_id from ims_md_educational where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_educational
            set difficulty_s = :difficulty_s, difficulty_v = :difficulty_v
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_educational (ims_md_id, difficulty_s, difficulty_v)
            values
            (:ims_md_id, :difficulty_s, :difficulty_v) "
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Difficulty
template::list::create \
    -name d_ed_dif \
    -multirow d_ed_dif \
    -no_data "No Difficulty Type Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	diff {
            label "Difficulty"
        }
    }

db_multirow d_ed_dif select_ed_dif {
    select 
        '[' || difficulty_s || '] ' || difficulty_v as diff,
        ims_md_id
    from 
           ims_md_educational
    where
           ims_md_id = :ims_md_id
} 
