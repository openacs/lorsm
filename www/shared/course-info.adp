<master>
  <property name="title">@title;noquote@</property>
  <property name="context">@context;noquote@</property>

  
<blockquote>
<table class="list" cellpadding="3" cellspacing="1" width="70%">
    <tr class="list-header">
        <th class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" colspan="2">
        Course Information
        </th>
    </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                Course Name:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0; font-weight: bold;">
                @course_name;noquote@
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                Version:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
                  @version;noquote@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                Metadata?:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
         	<if @man_metadata@ eq "Yes">
	           <a href="md/?ims_md_id=@man_id@">Yes</a>
                </if>
	        <else>
                  No
                </else>
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                Identifier:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @identifier@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                Is SCORM?:
              </td>
              <td 
         	<if @isscorm@ eq "Yes">
	           class="list" style="font-weight: bold;"
                </if>
	        <else>
                   class="list"
                </else>
                valign="top" align="left">@isscorm;noquote@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                Created By:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @created_by@
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                Date:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @creation_date;noquote@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                Submanifests:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @submanifests@
              </td>
          </tr>
              <tr class="list-even last">
        <if @active@ eq 0>
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                Add course to my class now:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                     <div style="float: right;">
	                  <a href="@shared_url@" class="button">Add Course</a>
                     </div>
              </td>
        </if>
        <else>
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%" colspan="2">
                  Course already part of your class
              </td>
        </else>
          </tr>
    <tr class="list-header">
        <th class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" colspan="2">
         Organizations
        </th>
    </tr>
              <tr class="list-odd">
              <td  valign="top" style="background-color: #f0f0f0; font-weight: bold;" colspan="2">

              </td>
          </tr>
              <tr class="list-odd">
              <td  valign="top" style="background-color: #f0f0f0; font-weight: bold;" colspan="2">
          @orgs_list;noquote@
              </td>
          </tr>
</table>
</blockquote>

<hr>
