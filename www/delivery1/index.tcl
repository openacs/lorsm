# packages/lorsm/www/delivery/index.tcl

ad_page_contract {
    
    Course Delivery Based on IMS Content Packaging Structure
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-09
    @arch-tag cfea182c-c686-4bee-be61-ec73f3d3a10f
    @cvs-id $Id$
} {
    man_id:integer,notnull  
} -properties {
} -validate {
} -errors {
}
if {[db_0or1row manifest "
    select 
           cp.man_id,
           cp.course_name,
           cp.identifier,
           cp.version,
           text 'Yes' as hello,
           case
              when hasmetadata = 't' then 'Yes'
              else 'No'
           end as man_metadata,
           case 
              when isscorm = 't' then 'Yes'
              else 'No'
           end as isscorm,
           cp.fs_package_id,
           cp.folder_id,
	   acs.creation_user,
	   acs.creation_date,
	   acs.context_id
    from
           ims_cp_manifests cp, acs_objects acs
    where 
           cp.man_id = acs.object_id
	   and  cp.man_id = :man_id
           and  cp.parent_man_id = 0"]} {

    
    # Course Name
    if {[empty_string_p $course_name]} {
	set course_name "[_ lorsm.No_course_Name]"
    } 

    # Version
    if {[empty_string_p $version]} {
	set version "[_ lorsm.No_version_Available]"
    } 
    
    # Instance
    set instance [apm_package_key_from_id $fs_package_id]

    # Folder
    set folder [apm_package_url_from_id $fs_package_id]?[export_vars folder_id]

    # Student tracking
    set package_id [ad_conn package_id]
    set community_id [dotlrn_community::get_community_id]
    set user_id [ad_conn user_id]

    if {[lorsm::track::istrackable -course_id $man_id -package_id $package_id]} {

	set track_id [lorsm::track::new \
			  -user_id $user_id \
			  -community_id $community_id \
			  -course_id $man_id]
    } else {
	set track_id 0
    }

} else {

    set display 0
    
}


