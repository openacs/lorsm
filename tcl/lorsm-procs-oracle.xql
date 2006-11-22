<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="lorsm::get_item_list.organizations">      
      <querytext>
	select org.org_id, org.org_title as org_title,org.hasmetadata,
		(select level 
		from acs_objects 
		connect by prior object_id = context_id
		start with object_id = org.org_id) as indent
	from ims_cp_organizations org
	where man_id = :man_id
	order by org_id
      </querytext>
</fullquery>


<fullquery name="lorsm::get_folder_labels.get_url">      
      <querytext>
	select 0 as tree_level, '' as name , 'Home' as title from dual
	UNION
	select t.tree_level, i.name, content_item.get_title(t.context_id) as title
	from (select o.context_id, level as tree_level
		from (select * from acs_objects where object_id = :item_id) o
		connect by prior object_id = context_id
		start with context_id <> content_item.get_root_folder()
		) t,
	cr_items i
	where i.item_id = t.context_id
	order by tree_level
      </querytext>
</fullquery>

<fullquery name="lorsm::init.get_item_id">      
      <querytext>
	select content_item.get_id(
			item_path => :url,
			root_folder_id => :content_root,
			resolve_index => 'f'
		) as item_id from dual
      </querytext>
</fullquery>

<fullquery name="lorsm::init.get_template_url">      
      <querytext>
        select 
          content_item.get_live_revision(content_item.get_template(:item_id, :context)) as template_id,
          content_template.get_path(content_item.get_template(:item_id, :context),:template_root) as template_url 
        from 
          dual
      </querytext>
</fullquery>

<fullquery name="lorsm::init_all.get_template_url">      
      <querytext>
        select 
          content_template.get_path(
          content_item.get_template(:item_id, :context),:template_root) as template_url 
        from 
          dual
      </querytext>
</fullquery>

</queryset>
