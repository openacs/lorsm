# packages/lorsm/www/choose_presentation_format.tcl

ad_page_contract {

	Show a list of available presentation formats so that user can choose one.

	@author Jonatan Tierno (jonatantierno@inv.it.uc3m.es)
	@creation-date 2004-03-31
	@arch-tag 208f2801-d110-45d3-9401-d5eae1f72c93
	@cvs-id  $Id$
} {
	man_id:integer,notnull
} -properties {
	context:onevalue
} -validate {
} -errors {
}


if { [ db_0or1row get_selected "
	select presentation_id as selected_presentation from ims_cp_manifests where man_id=:man_id;
"] } {} else { set selected_presentation "0"}

 template::list::create \
 	-name available_presentation_formats \
	-multirow apf \
	-key presentation_id \
	-pass_properties selected_presentation \
	-elements {
		selected {
			label #lorsm.Selected#

		        display_template { 
				   <input name="selected_presentation" value="@apf.presentation_id@" type="radio" <if @selected_presentation@ eq @apf.presentation_id@>checked="checked"</if>>
			}
		}
		presentation_id {
			hide_p 1
		}	
		presentation_name {
			label #lorsm.Presentation_name#
			display_col presentation_name
		}
		
	}
	
db_multirow apf apf_sql "
	select pf.presentation_id as presentation_id, pf.presentation_name as presentation_name from lors_available_presentation_formats as pf;
" 
# set context & title
set context [list "[_ lorsm.Course_Structure]"]
set title "[_ lorsm.Course_Structure]"

		
