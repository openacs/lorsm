# packages/lorsm/www/change_presentation_format.tcl

ad_page_contract {

	Update course presentations.

	@author Jonatan Tierno (jonatantierno@inv.it.uc3m.es)
	@creation-date 2004-03-31
	@arch-tag 208f2801-d110-45d3-9401-d5eae1f72c93
	@cvs-id  $Id$
    } {
	    man_id:integer,notnull
	    selected_presentation:integer,notnull
    } -properties {
    } -validate {
    } -errors {
}
						    

if { [ db_0or1row get_selected "
        select presentation_id from ims_cp_manifests where man_id=:man_id and presentation_id is not null limit 1
	"] } {\
	set message #lorsm.Presentation_format_modified#
} else {\
	set message #lorsm.Presentation_format_added#
} 
	
db_dml change_update "update ims_cp_manifests set presentation_id = :selected_presentation where man_id = :man_id" 

ad_returnredirect -message $message course-structure?man_id=$man_id
						   
