# packages/lorsm/www/md/technicalmd/technical_dur.tcl

ad_page_contract {
    
    Add/Edit Technical MD Duration
    
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
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../technicalmd" \\\i\\m\\s_md_id] "Technical MD"] "Add/Edit Duration"]
set title "Edit Technical MD Duration"

# Form

ad_form -name technicalmd_dur \
    -cancel_url ../technicalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {duration:text,nospell
	{section "Add/Edit Technical MD Duration"}
        {html {size 10}}
	{help_text "Time the continuous learning object is intended to take (in seconds)"}
        {label "Duration:"}
    }

    {duration_l:text,nospell,optional
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }

    {duration_s:text,nospell,optional
        {html {size 10}}
	{help_text "Source of vocabulary items i.e.: 'LOMv1.0'"}
        {label "Source:"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the tech duration details already exist...

    if {[db_0or1row select_duration {select ims_md_id from ims_md_technical where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_technical
            set duration_s = :duration_s,
            duration_l = :duration_l,
            duration = :duration
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_technical (ims_md_id, duration_l, duration_s)
            values
            (:ims_md_id, :duration_l, :duration_s)"
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../technicalmd" {ims_md_id}]
        ad_script_abort
} 

# Technical Duration
template::list::create \
    -name d_te_dur \
    -multirow d_te_dur \
    -no_data "No Duration Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        duration_sec {
            label "Duration (Seconds)"
        }
	duration_l {
	    label "Language"
	}
	duration_s {
	    label "Source"
	}

    }

db_multirow d_te_dur select_te_dur {
    select 
        duration_l,
        duration_s,
        duration || 's' as duration_sec,
        ims_md_id
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
} 
