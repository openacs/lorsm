<?xml version="1.0"?>
<queryset>

<fullquery name="lorsm::fix_href.select_folder_key">
      <querytext>
      select key 
      from fs_folders 
      where folder_id = :folder_id
      </querytext>
</fullquery>

<fullquery name="lorsm::get_course_name.course_name">
      <querytext>
      select course_name 
      from ims_cp_manifests 
      where man_id = :manifest_id
      </querytext>
</fullquery>


<fullquery name="lorsm::fix_href2.select_folder_key">      
      <querytext>
      select key 
      from fs_folders 
      where folder_id = :folder_id
      </querytext>
</fullquery>

<fullquery name="lorsm::get_item_list.sql">      
      <querytext>
      select i.parent_item, i.ims_item_id, i.item_title as item_title
      from acs_objects o, ims_cp_items i, cr_items cr
      where o.object_type = 'ims_item_object' 
      and i.org_id = :org_id and o.object_id = i.ims_item_id
      and cr.item_id = ( select item_id from cr_revisions where revision_id = i.ims_item_id)
      and exists (select 1
                  from acs_object_party_privilege_map p
                  where p.object_id = i.ims_item_id 
                  and p.party_id = :user_id
                  and p.privilege = 'read')
      order by i.sort_order, o.object_id --, cr.tree_sortkey
      </querytext>
</fullquery>

<fullquery name="lorsm::record_view.manifest_info">      
      <querytext>
      select fs_package_id, folder_id 
      from ims_cp_manifests 
      where man_id = :man_id
      </querytext>
</fullquery>

<fullquery name="lorsm::record_view.select_folder_key">      
      <querytext>
      select key
      from fs_folders 
      where folder_id = :folder_id
      </querytext>
</fullquery>

<fullquery name="lorsm::record_view.href">      
      <querytext>
      select href 
      from ims_cp_resources r, ims_cp_items_to_resources ir 
      where ir.ims_item_id = :item_id and ir.res_id = r.res_id
      </querytext>
</fullquery>

<fullquery name="lorsm::record_view.item_info">      
      <querytext>
      select item_title 
      from ims_cp_items
      where ims_item_id = :item_id
      </querytext>
</fullquery>

<fullquery name="lorsm::get_content.get_revision">      
      <querytext>

        select live_revision from cr_items where item_id = :ims_item_id

      </querytext>
</fullquery>

<fullquery name="lorsm::get_content.get_mime_type">      
      <querytext>

        select mime_type from cr_revisions 
        where revision_id = :revision_id

      </querytext>
</fullquery>

<fullquery name="lorsm::get_content.get_content_type">      
      <querytext>

        select content_type from cr_items 
        where item_id = :item_id

      </querytext>
</fullquery>

<fullquery name="lorsm::get_content.get_table_name">      
      <querytext>

        select table_name from acs_object_types 
        where object_type = :content_type

      </querytext>
</fullquery>

<partialquery name="lorsm::get_content.content_as_text">
	<querytext>

	, content as text

	</querytext>
</partialquery>

<fullquery name="lorsm::get_content.get_content">      
      <querytext>

        select 
           x.*, 
          :content_type as content_type
          $text_sql
        from
          cr_revisions r, ${table_name}x x
        where
          r.revision_id = :revision_id
        and 
          x.revision_id = r.revision_id

      </querytext>
</fullquery>

<fullquery name="lorsm::init.get_live_revision">      
      <querytext>

    select live_revision from cr_items where item_id = :item_id

      </querytext>
</fullquery>

<fullquery name="lorsm::init.get_item_type">      
      <querytext>
      select content_type 
      from cr_items 
      where item_id=:item_id
      </querytext>
</fullquery>

<fullquery name="lorsm::init.get_template_info">      
      <querytext>
    select item_id, content_type
    from cr_items
    where item_id = :item_id
      </querytext>
</fullquery>


<fullquery name="lorsm::get_root_folder_id.get_root_folder">      
      <querytext>
         select folder_id from cr_folders where label = 'LORSM Root Folder'
      </querytext>
</fullquery>

<fullquery name="lorsm::get_folder_id.get_root_folder">      
      <querytext>
      select folder_id 
      from cr_folders 
      where label = :name
      </querytext>
</fullquery>

<fullquery name="lorsm::get_items_indent.get_items_count">      
      <querytext>
      select count(ims_item_id)
      from ims_cp_items 
      where ims_item_id in ( 
           select live_revision
           from cr_items where content_type = 'ims_item_object') 
      and org_id = :org_id
      </querytext>
</fullquery>

<fullquery name="lorsm::get_items_indent.get_root_item">      
      <querytext>
      select ims_item_id 
      from ims_cp_items 
      where parent_item = :org_id and org_id = :org_id
      </querytext>
</fullquery>

<fullquery name="lorsm::get_items_indent.get_items">      
      <querytext>
      select ims_item_id 
      from ims_cp_items 
      where parent_item = :item_id and org_id = :org_id
      </querytext>
</fullquery>

  <fullquery name="callback::MergeShowUserInfo::impl::lorsm.sel_student_track">      
    <querytext>
      select track_id from
      lorsm_student_track
      where user_id = :user_id
    </querytext>
  </fullquery>

  <fullquery name="callback::MergeShowUserInfo::impl::lorsm.sel_student_bookmark">      
    <querytext>
      select community_id 
      from lorsm_student_bookmark
      where user_id = :user_id
    </querytext>
  </fullquery>
  
  <fullquery name="callback::MergePackageUser::impl::lorsm.student_track">      
    <querytext>
      update lorsm_student_track
      set user_id = :to_user_id
      where user_id = :from_user_id
    </querytext>
  </fullquery>
  
  <fullquery name="callback::MergePackageUser::impl::lorsm.student_bookmark">      
    <querytext>
      update lorsm_student_bookmark
      set user_id = :to_user_id
      where user_id = :from_user_id
    </querytext>
  </fullquery>

<fullquery name="lorsm::register_xml_object_id.get_package_id">      
      <querytext>
      select dotlrn_community_applets.package_id 
      from dotlrn_community_applets, apm_packages 
      where dotlrn_community_applets.package_id=apm_packages.package_id
      and community_id = :community_id and package_key='lorsm'
      </querytext>
</fullquery>

  
</queryset>