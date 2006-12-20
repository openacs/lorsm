<?xml version="1.0"?>

<queryset>

<fullquery name="manifest">      
      <querytext>
	select cp.course_name, cp.fs_package_id, isscorm,
	  pf.folder_name, pf.format_name
	from ims_cp_manifests cp, lorsm_course_presentation_fmts pf
	where cp.man_id = :man_id and  cp.parent_man_id = 0
	and cp.course_presentation_format = pf.format_id 
      </querytext>
</fullquery>

</queryset>
