<master>
<property name="title">Upload an IMS/SCORM Content Package Course</property>
<property name="context">@context;noquote@</property>

<table width="100%">
  <tr>
    <td valign="top">
        <h2>Shared Courses in the Repository</h2>
     </td>
  <tr>
   <td>
     <blockquote>
        <p>You can add courses already existing in the repository
        <include src="lib/repository-shared-courses">
     </blockquote>
   </td>
 </tr>
  <tr>
    <td valign="top">
        <h2>Add your own course</h2>
     </td>
  <tr>
   <td>
     <blockquote>
        <p>We have detected the root folder for <a href="@fs_url@">@folder_name;noquote@</a> and we will import your course in this folder.</p>
        <formtemplate id=course_upload></formtemplate>
     </blockquote>
   </td>
 </tr>
</table>
