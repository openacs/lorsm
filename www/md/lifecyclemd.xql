<?xml version="1.0"?>
<queryset>

<fullquery name="select_lf_ver">
  <querytext>
	select version_l, version_s
	from ims_md_life_cycle
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_lf_stat">
  <querytext>
      select status_s, status_v
      from ims_md_life_cycle
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_lf_cont">
  <querytext>
    select lfc.role_v,  lfc.role_s, 
	lfce.entity, lfc.cont_date, 
        lfc.cont_date_l, lfc.cont_date_s
      from ims_md_life_cycle_contrib lfc, ims_md_life_cycle_contrib_enty lfce 
      where lfc.ims_md_lf_cont_id = lfce.ims_md_lf_cont_id 
      and lfc.ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>