<html>
<head>
<title>@course_name@</title>

<frameset rows="30,*" border=0>
<frame src="top?man_id=@man_id@&track_id=@track_id@" name="top">
<frame src="<if @ims_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>" name="content">
</frameset>
