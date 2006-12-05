<?xml version="1.0"?>
<queryset>

<fullquery name="select_md_gen_cover">
  <querytext>
	select * 
	from ims_md_general_cover 
	where ims_md_ge_cove_id = :ims_md_ge_cove_id and ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
	update ims_md_general_cover
	set cover_l = :cover_l, cover_s = :cover_s
	where ims_md_ge_cove_id = :ims_md_ge_cove_id 
  </querytext>
</fullquery>

<fullquery name="do_insert">
  <querytext>
	insert into ims_md_general_cover (ims_md_ge_cove_id, ims_md_id, cover_l, cover_s)
	values
	(:ims_md_ge_cove_id, :ims_md_id, :cover_l, :cover_s)
  </querytext>
</fullquery>

<fullquery name="select_ge_cover">
  <querytext>
	select cover_l, cover_s, ims_md_ge_cove_id,
           ims_md_id
	from ims_md_general_cover
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>