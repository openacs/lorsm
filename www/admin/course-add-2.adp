<master>
<property name="context">@context;noquote@</property>

<h2>#lorsm.lt_Preliminary_informati#</h2>

<listtemplate name="d_info"></listtemplate>

<if @isSCORM@ eq 1>
    <p style="color:green">
        #lorsm.lt_The_uploaded_file_is_#
        <strong>#lorsm.lt_SCORM_complaint_packa#</strong>
    </p>
</if>


<if @isSCORM@ eq 1>
    <h3>#lorsm.SCORM_Package_Info#</h3>
    <listtemplate name="d_SCORM_package_info"></listtemplate>
</if>


<if @isSCORM@ eq 0>
    <h3>#lorsm.IMS_Package_Info#</h3>
    <if @isBB@ eq 1>
        <p style="color:green; font-size: smaller">
            #lorsm.lt_The_uploaded_file_is_#
            <strong>#lorsm.lt_Blackboard_6_complain#</strong>.
        </p>
    </if>

    <listtemplate name="d_IMS_package_info"></listtemplate>
</if>

<p style="font-size: smaller">
    <strong>#lorsm.Note#</strong>
    #lorsm._the_package_has#
    <strong>#lorsm.not_yet#</strong>
    #lorsm.lt_being_added_to_the_Le#
</p>

<formtemplate id=course_upload></formtemplate>
