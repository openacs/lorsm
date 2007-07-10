<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title>@course_name@</title>
</head>
<frameset cols="200,*" border=0>
<frame src="menu?man_id=@man_id@<if @ims_id@ defined>&ims_id=@ims_id@</if><if @track_id@ defined>&track_id=@track_id@</if>" name="toc">
<frame src="<if @ims_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>" name="content">
</frameset>
    </html>
