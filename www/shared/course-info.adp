<master>
  <property name="title">@title;noquote@</property>
  <property name="context">@context;noquote@</property>

  
<blockquote>
<table class="list" cellpadding="3" cellspacing="1" width="70%">
    <tr class="list-header">
        <th class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" colspan="2">
        #lorsm.Course_Information#
        </th>
    </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Course_Name#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0; font-weight: bold;">
                @course_name;noquote@
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Version#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
                  @version;noquote@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Metadata#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
         	<if @man_metadata@ eq "Yes">
	           <a href="md/?ims_md_id=@man_id@">#lorsm.Yes#</a>
                </if>
	        <else>
                  #lorsm.No#
                </else>
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Identifier#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @identifier@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                <#Is_SCORM_? Is SCORM?:#>
              </td>
              <td 
         	<if @isscorm@ eq "Yes">
	           #lorsm.lt_classlist_stylefont-w#
                </if>
	        <else>
                   class="list"
                </else>
                valign="top" align="left">@isscorm;noquote@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Created_By#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @created_by@
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Date#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @creation_date;noquote@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Submanifests#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @submanifests@
              </td>
          </tr>
              <tr class="list-even last">
        <if @active@ eq 0>
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.lt_Add_course_to_my_clas#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                     <div style="float: right;">
	                  <a href="@shared_url@" class="button">#lorsm.Add_Course#</a>
                     </div>
              </td>
        </if>
        <else>
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%" colspan="2">
                  #lorsm.lt_Course_already_part_o#
              </td>
        </else>
          </tr>
    <tr class="list-header">
        <th class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" colspan="2">
         #lorsm.Organizations#
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

