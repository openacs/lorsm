<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../lib/md-record"
    ims_md_id="@ims_md_id;noquote@"/>

  <table cellspacing="2" cellpadding="2" border="0">
    <tr class="form-section">
      <th colspan="2">Lifecycle Metadata</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Version: </td>
      <td><listtemplate name= "d_lf_ver"></listtemplate></td>
    </tr>   

    <tr class="form-section">
      <td class="form-section">Status: </td>
      <td><listtemplate name= "d_lf_stat"></listtemplate></td>
    </tr>   

    <tr class="form-section">
      <td class="form-section">Contributes: </td>
      <td><listtemplate name= "d_lf_cont"></listtemplate></td>
    </tr>   


  </table>
