<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../lib/md-record"
    ims_md_id="@ims_md_id;noquote@"/>

  <table cellspacing="2" cellpadding="2" border="0">
    <tr class="form-section">
      <th colspan="2">Rights Metadata</th>
    </tr>

    <tr class="form-section">
      <td class="form-section">Cost: </td>
      <td><listtemplate name= "d_ri_cost"></listtemplate></td>
    </tr>   

     <tr class="form-section">
      <td class="form-section">Copyright or other Restrictions: </td>
      <td><listtemplate name= "d_ri_caor"></listtemplate></td>
    </tr>   

     <tr class="form-section">
      <td class="form-section">Description: </td>
      <td><listtemplate name= "d_ri_desc"></listtemplate></td>
    </tr>   

  </table>