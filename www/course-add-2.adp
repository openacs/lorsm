<master>
<property name="context">@context;noquote@</property>

<p>  

<h2>Preliminary information</h2>
<p>


<listtemplate name="d_info"></listtemplate>
<p>
<if @isSCORM@ eq 1>
  <font color="green">The uploaded file is a <b>SCORM complaint package</b></font>
  <p>
</if>
<p>

<if @isSCORM@ eq 1>
<h3>SCORM Package Info</h3>
<listtemplate name="d_SCORM_package_info"></listtemplate>
<p>
</if>


<if @isSCORM@ eq 0>
<h3>IMS Package Info</h3>
  <if @isBB@ eq 1>
  <font color="green" size=\"-1\">  The uploaded file is a <b>Blackboard 6 complaint package</b>.</font>
  <p>  
  </if>

<listtemplate name="d_IMS_package_info"></listtemplate>
<p>
</if>
<small><b>Note</b>: the package has <b>not yet</b> being added to the Learning Object Repository.


<formtemplate id=course_upload></formtemplate>



