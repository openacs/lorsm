<?xml version="1.0"?>
<queryset>

<fullquery name="select_size">
  <querytext>
	select ims_md_id 
	from ims_md_educational 
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
      update ims_md_educational
      set type_lrn_time_s = :type_lrn_time_s, 
      type_lrn_time_l = :type_lrn_time_l,
      type_lrn_time = :type_lrn_time
      where ims_md_id = :ims_md_id 
  </querytext>
</fullquery>

<fullquery name="do_insert">
  <querytext>
      insert into ims_md_educational (ims_md_id, type_lrn_time_s, type_lrn_time_l, type_lrn_time)
      values
      (:ims_md_id, :type_lrn_time_s, :type_lrn_time_l, :type_lrn_time) 
  </querytext>
</fullquery>

<fullquery name="select_ed_tlt">
  <querytext>
      select type_lrn_time as tlt, ims_md_id
       type_lrn_time_l, type_lrn_time_s
      from ims_md_educational
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>