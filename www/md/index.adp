<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../lib/md-record"
    ims_md_id="@ims_md_id;noquote@"/>

<p>
<if @write_p@ eq 1>
 You can <a href="@link@">upload a XML LOM metadata node</a> to add/change the metadata for this record.
</if>
<br>
<if @read_p@ eq 1>
 Here's a link to the actual element
</if>

