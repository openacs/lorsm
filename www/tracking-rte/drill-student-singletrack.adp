<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<BR>
Data for the selected session:
<HR>
<B>Session data: (for lorsm_cmi_core session: @thistrack@)</B>
<HR>
Data regarding this session:
<li>
id: @student_id@
</li>
<li>
name: @student_name@
</li>
<li>
location: @lesson_location@
</li>
<li>
credit: @credit@
</li>
<li>
status: @lesson_status@
</li>
<li>
entry: @entry@
</li>
<li>
score: @score_raw@
</li>
<li>
total time: @total_time@ (seconds - last session excluded) <BR>
</li>
<li>
last session time: @session_time@ (seconds) <BR>
</li>
<li>
comments: @comments@ 
</li>
<li>
mode: @lesson_mode@ 
</li>
<li>
launch data: @launch_data@ 
</li>
<li>
suspend data: @suspend_data@ 
</li>
<li>
Session initialization time stamp: @time_stamp@<BR>
</li>

<%=
	#time stamp (creation date for this entry must be = first track below) @time_stamp@<BR>
%>

<HR>
Data below is from 'usual' lors tracking and is not provided as scorm compliance.
<HR>
<listtemplate name="student_track">
</listtemplate>
<HR>


