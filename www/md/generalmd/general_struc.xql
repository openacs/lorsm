<?xml version="1.0"?>
<queryset>

<fullquery name="select_structure">
  <querytext>
	select ims_md_id 
	from ims_md_general 
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
	update ims_md_general
	set structure_v = :structure_v, structure_s = :structure_s
	where ims_md_id = :ims_md_id 
  </querytext>
</fullquery>

<fullquery name="do_insert">
  <querytext>
	insert into ims_md_general (ims_md_id, structure_v, structure_s)
	values
	(:ims_md_id, :structure_v, :structure_s)
  </querytext>
</fullquery>

<fullquery name="select_ge_struc">
  <querytext>
	select structure_s, structure_v, ims_md_id
	from ims_md_general
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>