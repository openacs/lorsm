<?xml version="1.0"?>
<queryset>

<fullquery name="select_rel_resource">
  <querytext>
	select * 
	from ims_md_relation_resource 
	where ims_md_re_re_id = :ims_md_re_re_id 
	and ims_md_re_id = :ims_md_re_id
  </querytext>
</fullquery>

<fullquery name="do_update">
  <querytext>
	update ims_md_relation_resource
	set identifier = :identifier
	where ims_md_re_re_id = :ims_md_re_re_id 
  </querytext>
</fullquery>

<fullquery name="select_re_ident">
  <querytext>
	select rere.identifier, rere.ims_md_re_re_id,
	re.ims_md_re_id, re.ims_md_id
	from ims_md_relation_resource rere, ims_md_relation re
	where rere.ims_md_re_id = :ims_md_re_id
	and re.ims_md_re_id = :ims_md_re_id
  </querytext>
</fullquery>

</queryset>