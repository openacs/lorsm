<?xml version="1.0"?>
<queryset>

<fullquery name="select_ge_titles">
  <querytext>
	select title_l, title_s
	from ims_md_general_title
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ge_desc">
  <querytext>
      select descrip_l, descrip_s
      from ims_md_general_desc
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ge_cata">
  <querytext>
      select catalog, entry_l, entry_s
      from ims_md_general_cata
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ge_lang">
  <querytext>
      select language
      from ims_md_general_lang
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ge_key">
  <querytext>
      select keyword_l, keyword_s
      from ims_md_general_key
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ge_cover">
  <querytext>
      select cover_l, cover_s
      from ims_md_general_cover
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ge_struc">
  <querytext>
      select structure_s, structure_v
      from ims_md_general
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="select_ge_aggl">
  <querytext>
      select agg_level_s, agg_level_v
      from ims_md_general
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>


</queryset>