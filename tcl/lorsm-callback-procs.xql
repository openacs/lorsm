<?xml version="1.0"?>
<queryset>

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
  
</queryset>