<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<title>@course_name@</title>
</head>
<frameset cols="200,*">
<frame src="menu?man_id=@man_id@<if @ims_id@ defined>&amp;ims_id=@ims_id@</if><if @track_id@ defined>&amp;track_id=@track_id@</if>" name="toc" frameborder="0">
<frame src="<if @ims_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>" name="content" frameborder="0">
</frameset>
</html>
