<master>
<property name="context">@context;noquote@</property>

<p>  

<h2>Preliminary information</h2>
<p>

<blockquote>
<listtemplate name="d_info"></listtemplate>
<p>
<if @isSCORM@ eq 1>
  <font color="green">The uploaded file is a <b>SCORM complaint package</b></font>
  <p>
</if>
<small><b>Note</b>: the package has <b>not yet</b> being added to the Learning Object Repository.
<p>

<h2>Organizations</h2>
<listtemplate name="d_orgs"></listtemplate>
<p>

<blockquote>
<h3>Items</h3>
<listtemplate name="d_items"></listtemplate>
</blockquote>
<p>


<if @isSCORM@ eq 1>
<h3>SCOs</h3>
<listtemplate name="d_scos"></listtemplate>
<p>

<h3>Assets</h3>
<listtemplate name="d_assets"></listtemplate>
<p>
</if>


<if @isSCORM@ eq 0>
<h3>Resources</h3>
<listtemplate name="d_resources"></listtemplate>
<p>
</if>
</blockquote>

<listtemplate name="d_all_files"></listtemplate>

<blockquote>
@l_files@
</blockquote>

<p>
@all_files@

