<master>
  <property name="title">@title;noquote@</property>
  <property name="context">@context;noquote@</property>

<form name="input" action="change_presentation_format" method="get">
<input type="hidden" name="man_id" value="@man_id@">
<listtemplate name="available_presentation_formats"></listtemplate>
<input type="submit" value="Change format">
</form>
