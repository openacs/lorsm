<html>
<head>
<title>@course_name@</title>

<frameset cols="200,*" border=0>
<frame src="menu?man_id=@man_id@<if @ims_id@ defined>&ims_id=@ims_id@</if>&track_id=@track_id@" name="toc">
<frame src="<if @ims_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>" name="content">
</frameset>
