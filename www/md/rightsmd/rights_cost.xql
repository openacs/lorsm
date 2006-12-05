<?xml version="1.0"?>
<queryset>

<fullquery name="select_type">
  <querytext>
	select ims_md_id 
	from ims_md_rights 
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
	update ims_md_rights
	set cost_s = :cost_s, cost_v = :cost_v
	where ims_md_id = :ims_md_id 
  </querytext>
</fullquery>

<fullquery name="do_insert">
  <querytext>
	insert into ims_md_rights (ims_md_id, cost_s, cost_v)
        values
	(:ims_md_id, :cost_s, :cost_v) 
  </querytext>
</fullquery>

<fullquery name="select_ri_cost">
  <querytext>
	select cost_s, cost_v, ims_md_id
	from ims_md_rights
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>