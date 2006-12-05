<?xml version="1.0"?>
<queryset>

<fullquery name="select_an_annot">
  <querytext>
	select entity, ims_md_an_id, ims_md_id
	from ims_md_annotation 
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>