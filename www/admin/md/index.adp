<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @hasmetadata@ >
<include src="/packages/lorsm/lib/md-record"
    ims_md_id="@ims_md_id;noquote@"/>


<p>
<if @write_p@ eq 1>
 #lorsm.You_can# <a href="@link@">#lorsm.lt_upload_a_XML_LOM_meta#</a> #lorsm.lt_to_addchange_the_meta#
</if>
<br>
<if @read_p@ eq 1>
 #lorsm.lt_Heres_a_link_to_the_a#
</if>
</if>

<else>
<p>
#lorsm.lt_No_metadata_record_ex# 
<if @write_p@ eq 1>
<ul><li><a href=addmd?ims_md_id=@ims_md_id;noquote@>#lorsm.Add_metadata#</a></li></ul>
</if>
</else>

