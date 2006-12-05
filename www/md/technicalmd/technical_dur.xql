<?xml version="1.0"?>
<queryset>

<fullquery name="select_duration">
  <querytext>
	select ims_md_id 
	from ims_md_technical 
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
	update ims_md_technical
	set duration_s = :duration_s, duration_l = :duration_l,
	duration = :duration
	where ims_md_id = :ims_md_id 
  </querytext>
</fullquery>

<fullquery name="do_insert">
  <querytext>
	insert into ims_md_technical (ims_md_id, duration_l, duration_s)
	values
	(:ims_md_id, :duration_l, :duration_s)
  </querytext>
</fullquery>

<fullquery name="select_te_dur">
  <querytext>
	select duration_l, duration_s,
        duration || 's' as duration_sec,
        ims_md_id
	from ims_md_technical
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>