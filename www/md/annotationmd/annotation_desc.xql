<?xml version="1.0"?>
<queryset>

<fullquery name="select_md_ann_desc">
  <querytext>
      select * 
      from ims_md_annotation_descrip 
      where ims_md_an_de_id = :ims_md_an_de_id and ims_md_an_id = :ims_md_an_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
	update ims_md_annotation_descrip
	set descrip_l = :descrip_l,
	descrip_s = :descrip_s
	where ims_md_an_de_id = :ims_md_an_de_id
  </querytext>
</fullquery>

<fullquery name="do_insert">
  <querytext>
      insert into ims_md_annotation_descrip (ims_md_an_de_id, ims_md_an_id, descrip_l, descrip_s)
      values 
      (:ims_md_an_de_id, :ims_md_an_id, :descrip_l, :descrip_s)
  </querytext>
</fullquery>

<fullquery name="select_an_desc">
  <querytext>
      select ande.descrip_l, ande.descrip_s,
        ande.ims_md_an_de_id, an.ims_md_an_id, an.ims_md_id
      from ims_md_annotation_descrip ande, ims_md_annotation an
      where ande.ims_md_an_id = an.ims_md_an_id
      and ande.ims_md_an_id = :ims_md_an_id
  </querytext>
</fullquery>

</queryset>