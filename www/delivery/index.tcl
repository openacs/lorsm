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
	set course_name "No course Name"
    } 

    # Version
    if {[empty_string_p $version]} {
	set version "No version Available"
    } 
    
    # Instance
    set instance [apm_package_key_from_id $fs_package_id]

    # Folder
    set folder [apm_package_url_from_id $fs_package_id]?[export_vars folder_id]

} else {

    set display 0
    
}


