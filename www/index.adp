<master>

<if @admin_p@ eq 1>
<div style="float: right;">
  <a href="course-add" class="button">Add a Course</a>
</div>
</if>

<table width="100%">
  <tr>
    <td valign="top">
        <h2>Courses</h2>
        <listtemplate name="d_courses"></listtemplate>
   </td>
 </tr>
</table>
