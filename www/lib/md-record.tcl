set actions [list]

lappend actions  "General MD" [export_vars -base generalmd {ims_md_id}] "View General Metadata"
lappend actions  "Lifecycle MD" [export_vars -base lifecyclemd {ims_md_id}] "View Lifecycle Metadata"
lappend actions  "Meta MD" [export_vars -base metamd {ims_md_id}] "View Meta Metadata"
lappend actions  "Technical MD" [export_vars -base technicalmd {ims_md_id}] "View Technical Metadata"
lappend actions  "Educational MD" [export_vars -base educationalmd {ims_md_id}] "View Educational Metadata"
lappend actions  "Rights MD" [export_vars -base rightsmd {ims_md_id}] "View Rights Metadata"
lappend actions  "Relation MD" [export_vars -base relationmd {ims_md_id}] "View Relation Metadata"
lappend actions  "Annotation MD" [export_vars -base annotationmd {ims_md_id}] "View Annotation Metadata"
lappend actions  "Classification MD" [export_vars -base classificationmd {ims_md_id}] "View Classification Metadata"


# Presentation 
template::list::create \
    -name d_pres \
    -multirow d_pres \
    -no_data "-" \
    -actions  $actions \
    -elements {
        object_type {
            label "Object Type"
        }
	schema_and_version {
	    label "MD Schema and Version"
            html { align center }
	}
        admin {
            label "Edit Schema Details"
            display_eval {Modify Schema}
            link_url_eval {[export_vars -base "addmd" ims_md_id]}
            link_html {title "Admin Course" class button}
            html { align center }
        }

    }

db_multirow d_pres select_ge_titles {
    select
           object_type
    from 
           acs_objects
    where
           object_id = :ims_md_id
} 

db_multirow -extend { schema_and_version } d_pres select_schema_details {

    select 
            ims_md_id,
            schema, 
            schemaversion 
    from 
            ims_md 
    where 
            ims_md_id = :ims_md_id

} {
    set schema_and_version [concat $schema "  " $schemaversion]
}

