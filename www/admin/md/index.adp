<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @hasmetadata@ >
    <include src="/packages/lorsm/lib/md-record" ims_md_id="@ims_md_id;noquote@"/>
</if>
<else>
    <p>
        #lorsm.lt_No_metadata_record_ex#
        <if @write_p@ eq 1>
            <ul>
                <li><a href="addmd?ims_md_id=@ims_md_id;noquote@">#lorsm.Add_metadata#</a></li>
            </ul>
        </if>
</else>
