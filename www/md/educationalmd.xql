<?xml version="1.0"?>
<queryset>


<fullquery name="select_ed_intt">
  <querytext>
	select int_type_s, int_type_v 
	from ims_md_educational
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ed_lrt">
  <querytext>
      select lrt_s, lrt_v
      from ims_md_educational_lrt
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ed_intl">
  <querytext>
      select int_level_s, int_level_v
      from ims_md_educational
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ed_semd">
  <querytext>
      select sem_density_s, sem_density_v
      from ims_md_educational
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ed_ieur">
  <querytext>
      select ieur_s, ieur_v 
      from ims_md_educational_ieur
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ed_cont">
  <querytext>
      select context_s, context_v
      from ims_md_educational_context
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ed_tar">
  <querytext>
      select tar_l, tar_s  
      from ims_md_educational_tar
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ed_dif">
  <querytext>
      select difficulty_s, difficulty_v
      from ims_md_educational
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ed_tlt">
  <querytext>
      select type_lrn_time as tlt, type_lrn_time_l, type_lrn_time_s
      from ims_md_educational
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ed_desc">
  <querytext>
      select descrip_l,descrip_s
      from ims_md_educational_descrip
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ed_lang">
  <querytext>
      select language
      from ims_md_educational_lang
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>