<?xml version="1.0"?>
<queryset>

<fullquery name="select_md_class">
  <querytext>
	select * 
	from ims_md_classification 
	where ims_md_cl_id = :ims_md_cl_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
      update ims_md_classification
      set purpose_s = :purpose_s,
      purpose_v = :purpose_v
      where ims_md_cl_id = :ims_md_cl_id 
  </querytext>
</fullquery>

<fullquery name="select_cl_pur">
  <querytext>
      select purpose_s, purpose_v,
      ims_md_cl_id, ims_md_id
      from ims_md_classification
      where ims_md_cl_id = :ims_md_cl_id
  </querytext>
</fullquery>

</queryset>