ad_page_contract {
    Displays/Adds IMS Metadata Metametadata

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 30 January 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list "IMS Metadata Editor - Technical MD"]
set title "Technical MD"

# Technical Format
template::list::create \
    -name d_te_form \
    -multirow d_te_form \
    -no_data "No Format Available" \
    -actions [list "Add Format" [export_vars -base technicalmd_form {ims_md_id}] "Add another Format"] \
    -html { align right style "width: 100%;" } \
    -elements {
        format {
            label ""
        }
    }

db_multirow d_te_form select_te_form {
    select 
           format
    from 
           ims_md_technical_format
    where
           ims_md_id = :ims_md_id
} 

# Technical Size
template::list::create \
    -name d_te_size \
    -multirow d_te_size \
    -no_data "No Size Available" \
    -actions [list "Add Size" [export_vars -base technicalmd_size {ims_md_id}] "Add another Size"] \
    -html { align right style "width: 100%;" } \
    -elements {
        t_size {
            label ""
        }
    }

db_multirow d_te_size select_te_size {
    select 
           t_size
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
} 

# Technical Location
template::list::create \
    -name d_te_loca \
    -multirow d_te_loca \
    -no_data "No Location Available" \
    -actions [list "Add Location" [export_vars -base technicalmd_loca {ims_md_id}] "Add another Location"] \
    -html { align right style "width: 100%;" } \
    -elements {
        type {
            label ""
        }
        location {
            label ""
        }
    }

db_multirow d_te_loca select_te_loca {
    select 
           type, 
           location
    from 
           ims_md_technical_location
    where
           ims_md_id = :ims_md_id
} 

# Technical Requirements 
template::list::create \
    -name d_te_req \
    -multirow d_te_req \
    -no_data "No Requirements Available" \
    -actions [list "Add Requirements" [export_vars -base technicalmd_req {ims_md_id}] "Add another Requirement"] \
    -html { align right style "width: 100%;" } \
    -elements {
        type {
            label "Type"
        }
        name {
            label "Name"
        }
        min_version {
            label "Min Version"
        }
        max_version {
            label "Max Version"
        }
    }

db_multirow d_te_req select_te_req {
    select 
    '[' || type_s || ']' || ' ' || type_v as type, 
    '[' || name_s || ']' || ' ' || name_v as name,
    min_version,
    max_version
    from 
           ims_md_technical_requirement
    where
           ims_md_id = :ims_md_id
} 

# Technical Installation remarks
template::list::create \
    -name d_te_inst \
    -multirow d_te_inst \
    -no_data "No Installation Remarks Available" \
    -actions [list "Add Installation Remark" [export_vars -base technicalmd_inst {ims_md_id}] "Add another Installation remark"] \
    -html { align right style "width: 100%;" } \
    -elements {
        instl_rmrks {
            label ""
        }
    }

db_multirow d_te_inst select_te_inst {
    select 
    '[' || instl_rmrks_l || ']' || ' ' || instl_rmrks_s as instl_rmrks
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
}

# Technical Other Platform Requirements
template::list::create \
    -name d_te_otr \
    -multirow d_te_otr \
    -no_data "No Other Platform Requirements Available" \
    -actions [list "Add Other Platform Requirements" [export_vars -base technicalmd_otr {ims_md_id}] "Add another Other Platform Requiements"] \
    -html { align right style "width: 100%;" } \
    -elements {
        otr_plt {
            label ""
        }
    }

db_multirow d_te_otr select_te_otr {
    select 
    '[' || otr_plt_l || ']' || ' ' || otr_plt_s as otr_plt
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
}

# Technical Duration
template::list::create \
    -name d_te_dur \
    -multirow d_te_dur \
    -no_data "No Duration Available" \
    -actions [list "Add Duration" [export_vars -base technicalmd_dur {ims_md_id}] "Add another Duration"] \
    -html { align right style "width: 100%;" } \
    -elements {
        duration {
            label ""
        }
        dur_descrip {
            label ""
        }
    }

db_multirow d_te_dur select_te_dur {
    select 
    duration,
    '[' || duration_l || ']' || ' ' || duration_s as dur_descrip
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
}
