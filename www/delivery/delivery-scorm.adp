<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">

<html>
<head>
<SCRIPT LANGUAGE="javascript">
this.ses_renew=@ses_renew@;
this.menu_off=@menu_off@;
this.content_href = "<if @ims_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>";
</SCRIPT>

<title>@course_name@</title>
</head>

<if @debuglevel@ gt 0>
<frameset id="topframe" rows="100,100%" border=0> 
</if>
<else>
<frameset id="topframe" rows="*,100%" border=0> 
</else>
<frame src="applet?man_id=@man_id@&return_url=@return_url@<if @item_id@ defined>&item_id=@item_id@</if><if @ims_id@ defined>&ims_id=@ims_id@</if>&track_id=@track_id@<if @menu_off@ defined>&menu_off=@menu_off@</if>" name="AppletContainerFrame" scrolling=no>
<if @menu_off@ lt 1>
<frameset id="menuvscontent" cols="40%,*" border=0>
</if>
<else>
<frameset id="menuvscontent" cols="*,100%" frameborder=0 border=0 framespacing=0 name="page">
</else>
<if @debuglevel@ gt 0>
<frameset rows="50%,*" border=0 name="left" id="left" noresize border=0 frameborder=0 framespacing=0> 
</if>
<else>
<frameset rows="100%,*" border=0 name="left" id="left" noresize border=0 frameborder=0 framespacing=0> 
</else>

<frame src="blank.html" id="menu" name="menu" scrolling=auto>

<frameset rows="80%,*" border=0 name="DownLeftFrame" noresize border=0 frameborder=0 framespacing=0>
<frame src="blank.html" name="talk">
<frame src="keepalive" name="keepalive">
</frameset>
</frameset>
<frame src="blank-no-javascript.html" name="content" scrolling=auto>
</frameset>
</frameset>
</html>
