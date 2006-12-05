<?xml version="1.0"?>
<queryset>

<fullquery name="select_md_class_desc">
  <querytext>
	select * 
	from ims_md_classification_descrip 
	where ims_md_cl_de_id = :ims_md_cl_de_id and ims_md_cl_id = :ims_md_cl_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
      update ims_md_classification_descrip
      set descrip_l = :descrip_l,
      descrip_s = :descrip_s
      where ims_md_cl_de_id = :ims_md_cl_de_id
  </querytext>
</fullquery>

<fullquery name="do_insert">
  <querytext>
      insert into ims_md_classification_descrip (ims_md_cl_de_id, ims_md_cl_id, descrip_l, descrip_s)
      values 
      (:ims_md_cl_de_id, :ims_md_cl_id, :descrip_l, :descrip_s)
  </querytext>
</fullquery>

<fullquery name="select_cl_desc">
  <querytext>
      select clde.descrip_l, clde.descrip_s,
        clde.ims_md_cl_de_id, cl.ims_md_cl_id, cl.ims_md_id
      from ims_md_classification_descrip clde, ims_md_classification cl
      where clde.ims_md_cl_id = cl.ims_md_cl_id
      and clde.ims_md_cl_id = :ims_md_cl_id
  </querytext>
</fullquery>

</queryset>