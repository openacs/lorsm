<?xml version="1.0"?>
<queryset>

<fullquery name="select_md_md_scheme">
  <querytext>
	select * 
	from ims_md_metadata_scheme 
	where ims_md_md_sch_id = :ims_md_md_sch_id and ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
	update ims_md_metadata_scheme
	set scheme = :scheme
	where ims_md_md_sch_id = :ims_md_md_sch_id 
  </querytext>
</fullquery>

<fullquery name="do_insert">
  <querytext>
	insert into ims_md_metadata_scheme (ims_md_md_sch_id, ims_md_id, scheme)
	values
	(:ims_md_md_sch_id, :ims_md_id, :scheme)
  </querytext>
</fullquery>

<fullquery name="select_md_scheme">
  <querytext>
	select scheme, ims_md_id, ims_md_md_sch_id, scheme
	from ims_md_metadata_scheme
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>