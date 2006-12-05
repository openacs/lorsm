<?xml version="1.0"?>
<queryset>

<fullquery name="select_md_edu_lang">
  <querytext>
	select * 
	from ims_md_educational_lang 
	where ims_md_ed_la_id = :ims_md_ed_la_id and ims_md_id = :ims_md_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
      update ims_md_educational_lang
      set language = :language
      where ims_md_ed_la_id = :ims_md_ed_la_id 
  </querytext>
</fullquery>

<fullquery name="do_insert">
  <querytext>
            insert into ims_md_educational_lang (ims_md_ed_la_id, ims_md_id, language) 
            values (:ims_md_ed_la_id, :ims_md_id, :language)
  </querytext>
</fullquery>

<fullquery name="select_ed_lang">
  <querytext>
      select language, ims_md_ed_la_id, ims_md_id
      from ims_md_educational_lang
      where ims_md_id = :ims_md_id
  </querytext>
</fullquery>

</queryset>