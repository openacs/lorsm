<master>
<property name="title">#lorsm.lt_Upload_an_IMSSCORM_Co#</property>
<property name="context">@context;noquote@</property>

<table width="100%">
  <tr>
    <td valign="top">
        <h2>#lorsm.lt_Shared_Courses_in_the#</h2>
     </td>
  <tr>
   <td>
     <blockquote>
        <p>#lorsm.lt_You_can_add_courses_a#
        <include src="/packages/lorsm/lib/repository-shared-courses">
     </blockquote>
   </td>
 </tr>
  <tr>
    <td valign="top">
        <h2>#lorsm.Create_a_new_course#</h2>
     </td>
  <tr>
   <td>
     <blockquote>
<!--         <p>#lorsm.lt_We_have_detected_the_# <a
        href="@fs_url@">@folder_name;noquote@</a>
        #lorsm.lt_and_we_will_import_yo#</p> -->
        <include src="/packages/lors/lib/course-new" folder_id="@folder_id@">
                <h2>#lorsm.or_upload_existing_course#</h2>
                <formtemplate id=course_upload></formtemplate>
     </blockquote>
   </td>
 </tr>
</table>

