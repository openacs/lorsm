<?xml version="1.0"?>
<queryset>

<fullquery name="select_general_title">
  <querytext>
	select * 
	from ims_md_general_title 
	where ims_md_ge_ti_id = :ims_md_ge_ti_id and ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
	update ims_md_general_title
	set title_l = :title_l, title_s = :title_s
	where ims_md_ge_ti_id = :ims_md_ge_ti_id 
  </querytext>
</fullquery>

<fullquery name="do_insert">
  <querytext>
	insert into ims_md_general_title (ims_md_ge_ti_id, ims_md_id, title_l, title_s)
	values
	(:ims_md_ge_ti_id, :ims_md_id, :title_l, :title_s)
  </querytext>
</fullquery>

<fullquery name="select_ge_titles">
  <querytext>
	select title_l, title_s, ims_md_ge_ti_id,
           ims_md_id
	from ims_md_general_title
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>