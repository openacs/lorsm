<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../form-md-record/md-record" ims_md_id="@ims_md_id;noquote@" />

<hr>

<h3>List of General Metadata Catalog-Entries</h3>

<table cellspacing="2" cellpadding="2" border="0" width="50%">
    <tr class="form-section">
        <th colspan="2">General Metadata</th>
    </tr>

    <tr class="form-section">
        <td class="form-section">Catalog-Entries: </td>
        <td><listtemplate name= "d_gen_cata"></listtemplate></td>
    </tr>
</table>

<h3>#lorsm.lt_AddEdit_General_MD_Ca#</h3>

<formtemplate id="generalmd_cata" style="standard-lars"></formtemplate>
