<master>
  <property name="title">@title;noquote@</property>
  <property name="context">@context;noquote@</property>

  
<blockquote>
<table class="list" cellpadding="3" cellspacing="1">
    <tr class="list-header">
        <th class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" colspan="2">
        Course Information
        </th>
    </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">
                Course Name:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0; font-weight: bold;">
                <a href="@folder@">@course_name;noquote@</a>
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">
                Version:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
                  @version;noquote@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">
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
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">
                Identifier:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
                @identifier@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">
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
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">
                Storage Folder:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
                <a href="@folder@">@instance@</a>
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">
                Created By:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
                @created_by@
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">
                Date:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
                @creation_date;noquote@
              </td>
          </tr>
              <tr class="list-odd last">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;">
                Submanifests:
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
                @submanifests@
              </td>
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
