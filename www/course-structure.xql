<?xml version="1.0"?>
<queryset>

<fullquery name="get_versions">
  <querytext>
       select 
		count(revision_id)
       from 
		cr_revisions 
	where 
		item_id = ( 
			   select 
				   item_id 
                           from 
				   cr_revisions 
			   where 
				   revision_id = :man_id 
			   )
  </querytext>
</fullquery>

<fullquery name="get_folder_id">
  <querytext>
	    select 
	            item_id 
	    from 
	            cr_items 
	    where 
	            name = :instance and 
	            parent_id = :root_folder
  </querytext>
</fullquery>

<fullquery name="submans">
  <querytext>
           select 
                count(*) as submanifests 
           from 
                ims_cp_manifests 
           where 
                man_id = :man_id
              and
                parent_man_id = :man_id
  </querytext>
</fullquery>

</queryset>