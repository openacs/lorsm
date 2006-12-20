<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="template_root">      
      <querytext>
	select content_template.get_root_folder from dual
      </querytext>
</fullquery>

<fullquery name="get_item_id">
      <querytext>
	begin
    		:1 := content_item.get_id(:url, :content_root, 'f');
	end;
      </querytext>
</fullquery>
 


</queryset>
