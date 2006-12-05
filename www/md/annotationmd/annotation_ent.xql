<?xml version="1.0"?>
<queryset>

<fullquery name="select_md_ann">
  <querytext>
	select * 
	from ims_md_annotation 
	where ims_md_an_id = :ims_md_an_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
      update ims_md_annotation
      set entity = :entity
      where ims_md_an_id = :ims_md_an_id
  </querytext>
</fullquery>

<fullquery name="select_an_ent">
  <querytext>
      select entity, ims_md_an_id, ims_md_id
      from ims_md_annotation
      where ims_md_an_id = :ims_md_an_id
  </querytext>
</fullquery>

</queryset>