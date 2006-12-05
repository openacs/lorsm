<?xml version="1.0"?>
<queryset>

<fullquery name="select_general_lang">
  <querytext>
	select * 
	from ims_md_general_lang 
	where ims_md_ge_lang_id = :ims_md_ge_lang_id and ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
	update ims_md_general_lang
	set language = :language
	where ims_md_ge_lang_id = :ims_md_ge_lang_id 
  </querytext>
</fullquery>

<fullquery name="do_insert">
  <querytext>
	insert into ims_md_general_lang (ims_md_ge_lang_id, ims_md_id, language)
	values
	(:ims_md_ge_lang_id, :ims_md_id, :language)
  </querytext>
</fullquery>

<fullquery name="select_ge_lang">
  <querytext>
	select language, ims_md_ge_lang_id,
	ims_md_id
	from ims_md_general_lang
	where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>