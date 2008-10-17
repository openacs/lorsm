<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../form-md-record/md-record"
    ims_md_id="@ims_md_id;noquote@"
/>

<hr>

<h3>Lifecyle Metadata Status</h3>

  <table cellspacing="2" cellpadding="2" border="0" width="50%">
    <tr class="form-section">
      <th colspan="2">Lifecycle Metadata</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Status: </td>
      <td><listtemplate name= "d_lf_stat"></listtemplate></td>
    </tr>   

  </table>

<h3>#lorsm.lt_AddEdit_Lifecycle_Met_1#</h3>

 <formtemplate id="lifecyclemd_stat" style="standard-lars"></formtemplate>
