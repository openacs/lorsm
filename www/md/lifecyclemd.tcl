ad_page_contract {
    Displays/Adds IMS Metadata Lifecycle

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 30 January 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list "IMS Metadata Editor - Lifecycle MD"]
set title "Lifecycle MD"

# Lifecycle version
template::list::create \
    -name d_lf_ver \
    -multirow d_lf_ver \
    -no_data "No Version Available" \
    -actions [list "Add Version" [export_vars -base lifecycle_version {ims_md_id}] "Add Version"] \
    -html { align right style "width: 100%;" } \
    -elements {
        version_l {
            label ""
        }
        version_s {
            label ""
        }
    }

db_multirow d_lf_ver select_lf_ver {
    select version_l,
           version_s
    from 
           ims_md_life_cycle
    where
           ims_md_id = :ims_md_id
} 

# Lifecycle status
template::list::create \
    -name d_lf_stat \
    -multirow d_lf_stat \
    -no_data "No Version Available" \
    -actions [list "Add Status" [export_vars -base lifecycle_stat {ims_md_id}] "Add Status"] \
    -html { align right style "width: 100%;" } \
    -elements {
        status_s {
            label ""
        }
        status_v {
            label ""
        }
    }

db_multirow d_lf_stat select_lf_stat {
    select status_s,
           status_v
    from 
           ims_md_life_cycle
    where
           ims_md_id = :ims_md_id
} 


# Lifecycle Contrib
template::list::create \
    -name d_lf_cont \
    -multirow d_lf_cont \
    -no_data "No Contributors Available" \
    -actions [list "Add Contributors" [export_vars -base lifecycle_cont {ims_md_id}] "Add another Contributors"] \
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
    }

db_multirow d_lf_cont select_lf_cont {
select 
	lfc.role_v || ' ' || '[' || lfc.role_s || ']' as role,
    lfce.entity,
    lfc.cont_date,
    '[' || lfc.cont_date_l || ']' || ' ' || lfc.cont_date_s as cont_date_ls
from 
    ims_md_life_cycle_contrib lfc, 
    ims_md_life_cycle_contrib_entity lfce 
where 
    lfc.ims_md_lf_cont_id = lfce.ims_md_lf_cont_id 
and
    lfc.ims_md_id = :ims_md_id
} 
