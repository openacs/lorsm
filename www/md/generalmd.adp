<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../lib/md-record"
    ims_md_id="@ims_md_id;noquote@"/>

  <table cellspacing="2" cellpadding="2" border="0">
    <tr class="form-section">
      <th colspan="2">General Metadata</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Titles: </td>
      <td><listtemplate name= "d_gen_titles"></listtemplate></td>
    </tr>   

    <tr class="form-section">
     <td class="form-section">Catalog-Entries: </td>
     <td><listtemplate name= "d_gen_cata"></listtemplate></td>
    </tr>

    <tr class="form-section">
     <td class="form-section">Languages: </td>
     <td><listtemplate name= "d_gen_lang"></listtemplate></td>
    </tr>

    <tr class="form-section">
     <td class="form-section">Descriptions: </td>
     <td><listtemplate name= "d_gen_desc"></listtemplate></td>
    </tr>

    <tr class="form-section">
     <td class="form-section">Keywords: </td>
     <td><listtemplate name= "d_gen_key"></listtemplate></td>
    </tr>   

    <tr class="form-section">
        <td class="form-section">Coverage: </td>
        <td><listtemplate name= "d_gen_cover"></listtemplate></td>
    </tr>

    <tr class="form-section">
        <td class="form-section">Structure: </td>
        <td><listtemplate name= "d_gen_struc"></listtemplate></td>
    </tr>

    <tr class="form-section">
        <td class="form-section">Aggregation Level: </td>
        <td><listtemplate name= "d_gen_aggl"></listtemplate></td>
    </tr>

  </table>
