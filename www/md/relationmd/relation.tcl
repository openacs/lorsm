ad_page_contract {
    Displays/Adds IMS Metadata Relation

    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_re_id:integer
    ims_md_id:integer
    ims_md_re_re_id:integer
}

# set context & title
set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../relationmd" ims_md_id] "Relation MD"] "Relation Entry"]
set title "Relation MD"

# Relation Kind
template::list::create \
    -name d_re_kind \
    -multirow d_re_kind \
    -no_data "No Kind Available" \
    -actions [list "Add Kind" [export_vars -base relation_kind {ims_md_re_re_id ims_md_re_id ims_md_id}] "Add another Kind"] \
    -html { align right style "width: 100%;" } \
    -elements {
        kind_s {
            label ""
        }
	kind_v {
	    label ""
	}
    }

db_multirow d_re_kind select_re_kind {
    select kind_s,
           kind_v
    from 
           ims_md_relation
    where
           ims_md_re_id = :ims_md_re_id 
    and    ims_md_id = :ims_md_id
} 

# Relation Resource Identifier
template::list::create \
    -name d_re_ident \
    -multirow d_re_ident \
    -actions [list "Add Identifier" [export_vars -base relation_ident {ims_md_re_re_id ims_md_re_id ims_md_id}] "Add another Identifier"] \
    -no_data "No Resource Identifier Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        identifier {
	    label ""
	}
    }

db_multirow d_re_ident select_re_ident {
    select identifier
    from 
           ims_md_relation_resource
    where
           ims_md_re_id = :ims_md_re_id
    and    ims_md_re_re_id = :ims_md_re_re_id
}

# Relation Resource Catalog-Entry
template::list::create \
    -name d_re_cata \
    -multirow d_re_cata \
    -no_data "No Catalog-Entries Available" \
    -actions [list "Add Catalog-Entry" [export_vars -base relation_cata {ims_md_re_re_id ims_md_re_id ims_md_id}] "Add another Catalog-Entry"] \
    -html { align right style "width: 100%;" } \
    -elements {
        catalog {
	    label ""
	}
	entry_l {
	    label ""
	}
	entry_s {
	    label ""
	}
    }

db_multirow d_re_cata select_re_cata {
    select catalog,
           entry_l,
           entry_s
    from 
           ims_md_relation_resource_catalog
    where
           ims_md_re_re_id = :ims_md_re_re_id
}

# Relation Resource Description
template::list::create \
    -name d_re_desc \
    -multirow d_re_desc \
    -no_data "No Resource Description Available" \
    -actions [list "Add Description" [export_vars -base relation_desc {ims_md_re_re_id ims_md_re_id ims_md_id}] "Add another Description"] \
    -html { align right style "width: 100%;" } \
    -elements {
        descrip {
	    label ""
	}
    }

db_multirow d_re_desc select_re_desc {
    select '[' || descrip_l || ']' || ' ' || descrip_s as descrip
    from 
           ims_md_relation_resource
    where
           ims_md_re_id = :ims_md_re_id
    and    ims_md_re_re_id = :ims_md_re_re_id
}


