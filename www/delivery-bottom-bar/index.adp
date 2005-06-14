<html>
<head>
<title>@course_name@</title>

<frameset rows="90%,*" border=0>
<frame src="<if @ims_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>" name="content">
<frame src="bottom?man_id=@man_id@" name="bottom">
</frameset>
