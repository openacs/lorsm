# packages/lorsm/www/md/annotationmd/annotation_date.tcl

ad_page_contract {
    
    Add/Edit Annotation MD Date
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_an_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"] [list [export_vars -base "../annotationmd" ims_md_id] "Annotation MD"] [list [export_vars -base "annotation" {ims_md_id ims_md_an_id}] "Annotation Entry"] "Add/Edit Date"]
set title "Edit Annotation MD Date"


# Form

ad_form -name annotationmd_date \
    -cancel_url annotation?ims_md_id=$ims_md_id&ims_md_an_id=$ims_md_an_id \
    -mode edit \
    -form {

    ims_md_an_id:key(ims_md_annotation_seq)

    {date:text,nospell
	{section "Add/Edit Annotation MD Date"}	
	{html {size 10}}
	{help_text "Date of contribution"}
	{label "Date:"}
    }

    {date_l:text,nospell,optional	
	{html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English (Required if entering Description)"}
	{label "Language:"}
    }
    
    {date_s:text(textarea),nospell,optional
        {html {rows 2 cols 50}}
	{help_text "Date and Time description"}
        {label "Description:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

} -select_query  {select * from ims_md_annotation where ims_md_an_id = :ims_md_an_id

} -edit_data {
        db_dml do_update "
            update ims_md_annotation
            set date = :date,
            date_l = :date_l,
            date_s = :date_s
            where ims_md_an_id = :ims_md_an_id "

} -after_submit {
    ad_returnredirect [export_vars -base "annotation" {ims_md_an_id ims_md_id}]
        ad_script_abort
} 

# Annotation Date
template::list::create \
    -name d_an_date \
    -multirow d_an_date \
    -no_data "No Date Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	date {
            label "Date"
        }
	datels {
	    label "Description"
	}
    }

db_multirow d_an_date select_an_date {
    select date,
    '[' || date_l || '] ' || date_s as datels,
    ims_md_an_id,
    ims_md_id   
    from 
           ims_md_annotation
    where
           ims_md_an_id = :ims_md_an_id
} 
