# packages/lorsm/www/md/educationalmd/educational_semd.tcl

ad_page_contract {
    
    Add/Edit Educational MD Semantic Density
    
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

set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" ims_md_id] "Educational MD"] "Add/Edit Semantic Density"]
set title "Edit Educational MD Semantic Density"

# Form

ad_form -name educationalmd_semd \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {sem_density_s:text,nospell
	{section "Add/Edit Educational MD Semantic Density"}
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }

    {sem_density_v:text,nospell
        {html {size 10}}
	{help_text "Learning object's usefulness as compared to its size or duration"}
        {label "Semantic Density:"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the ED Semantic Density already exist...

    if {[db_0or1row select_size {select ims_md_id from ims_md_educational where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_educational
            set sem_density_s = :sem_density_s,
            sem_density_v = :sem_density_v
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_educational (ims_md_id, sem_density_s, sem_density_v)
            values
            (:ims_md_id, :sem_density_s, :sem_density_v) "
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Semantic Density
template::list::create \
    -name d_ed_semd \
    -multirow d_ed_semd \
    -no_data "No Semantic Density Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	semd {
            label "Semantic Density"
        }
    }

db_multirow d_ed_semd select_ed_semd {
    select 
        '[' || sem_density_s || '] ' || sem_density_v as semd,
        ims_md_id
    from 
           ims_md_educational
    where
           ims_md_id = :ims_md_id
} 
