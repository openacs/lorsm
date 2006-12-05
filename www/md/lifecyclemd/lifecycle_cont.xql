<?xml version="1.0"?>
<queryset>

<fullquery name="select_ims_contrib">
  <querytext>
	select * 
	from ims_md_life_cycle_contrib lfc, 
        ims_md_life_cycle_contrib_enty lfce 
	where lfc.ims_md_lf_cont_id = :ims_md_lf_cont_id
	and lfc.ims_md_id = :ims_md_id
	and lfce.ims_md_lf_cont_id = :ims_md_lf_cont_id
  </querytext>
</fullquery>

<fullquery name="update_lfc">
  <querytext>
	update ims_md_life_cycle_contrib
	set role_v = :role_v, role_s = :role_s, 
	cont_date = :cont_date, cont_date_l = :cont_date_l, 
	cont_date_s = :cont_date_s
	where ims_md_lf_cont_id = :ims_md_lf_cont_id
  </querytext>
</fullquery>

<fullquery name="update_lfce">
  <querytext>
      update ims_md_life_cycle_contrib_enty
      set entity = :entity
      where ims_md_lf_cont_id = :ims_md_lf_cont_id
  </querytext>
</fullquery>

<fullquery name="insert_lfc">
  <querytext>
	insert into ims_md_life_cycle_contrib (ims_md_lf_cont_id, ims_md_id, role_s, role_v, cont_date, cont_date_l, cont_date_s)
	values 
	(:ims_md_lf_cont_id, :ims_md_id, :role_s, :role_v, :cont_date, :cont_date_l, :cont_date_s)
  </querytext>
</fullquery>

<fullquery name="insert_lfce">
  <querytext>
      insert into ims_md_life_cycle_contrib_enty (ims_md_lf_cont_enti_id, ims_md_lf_cont_id, entity)
      values 
      (:ims_md_lf_cont_enti_id, :ims_md_lf_cont_id, :entity)
  </querytext>
</fullquery>

<fullquery name="select_lf_cont">
  <querytext>
	select lfc.role_v, lfc.role_s,
          lfce.entity, lfc.cont_date,
          lfc.cont_date_l, lfc.cont_date_s,
          lfc.ims_md_lf_cont_id, lfc.ims_md_id
	from  ims_md_life_cycle_contrib lfc, ims_md_life_cycle_contrib_enty lfce 
	where lfc.ims_md_lf_cont_id = lfce.ims_md_lf_cont_id
	and lfc.ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>