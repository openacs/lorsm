# packages/lorsm/www/md/educationalmd/educational_tlt.tcl

ad_page_contract {
    
    Add/Edit Educational MD Typical Learning Time
    
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
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../educationalmd" ims_md_id] "Educational MD"] "Add/Edit Typical Learning Time"]
set title "Edit Educational MD Typical Learning Time"

# Form

ad_form -name educationalmd_tlt \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {type_lrn_time_l:text,nospell,optional
	{section "Add/Edit Educational MD Typical Learning Time"}
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }

    {type_lrn_time_s:text(textarea),nospell,optional
        {html {rows 2 cols 50}}
	{help_text "Brief Description (Required if entering Language)"}
        {label "Description:"}
    }

    {type_lrn_time:text,nospell
        {html {size 20}}
	{help_text "Amount of time it takes to work with the resource"}
        {label "Typical Learning Time:"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the educational typical learning time details already exist...

    if {[db_0or1row select_size {select ims_md_id from ims_md_educational where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_educational
            set type_lrn_time_s = :type_lrn_time_s, 
            type_lrn_time_l = :type_lrn_time_l,
            type_lrn_time = :type_lrn_time
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_educational (ims_md_id, type_lrn_time_s, type_lrn_time_l, type_lrn_time)
            values
            (:ims_md_id, :type_lrn_time_s, :type_lrn_time_l, :type_lrn_time) "
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Typical Learning Time
template::list::create \
    -name d_ed_tlt \
    -multirow d_ed_tlt \
    -no_data "No Typical Learning Time Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	tlt {
            label "Typical Learning Time"
        }
	tlt_ls {
            label "Language"
        }
    }

db_multirow d_ed_tlt select_ed_tlt {
    select
    type_lrn_time as tlt,
    '[' || type_lrn_time_l || '] ' || type_lrn_time_s as tlt_ls,
    ims_md_id
    from 
           ims_md_educational
    where
           ims_md_id = :ims_md_id
} 
