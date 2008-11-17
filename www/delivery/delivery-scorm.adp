<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">

<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8">
        <SCRIPT TYPE="text/javascript">
            this.ses_renew=@ses_renew@;
            this.menu_off=@menu_off@;
            this.content_href = "<if @ims_id@ defined>
                                    @body_url;noquote@
                                </if>
                                <else>
                                    body?man_id=@man_id@
                                </else>";
        </SCRIPT>
        <title>@course_name@</title>
    </head>

    <if @debuglevel@ gt 0>
        <frameset id="topframe" rows="100,100%" title="#lorsm.SCORM_Player#">
    </if>
    <else>
        <frameset id="topframe" rows="*,100%" title="#lorsm.SCORM_Player#">
    </else>
            <frame src="applet?man_id=@man_id@&amp;return_url=@return_url@

    <if @item_id@ defined>
            &item_id=@item_id@
    </if>

    <if @ims_id@ defined>
            &ims_id=@ims_id@
    </if>

    &amp;track_id=@track_id@

    <if @menu_off@ defined>
            &amp;menu_off=@menu_off@
    </if>" name="AppletContainerFrame" scrolling=no frameborder="0" title="#lorsm.Applet_frame#">

    <if @menu_off@ lt 1>
            <frameset id="menuvscontent" cols="30%,*" title="#lorsm.Menu_area#">
    </if>
    <else>
            <frameset id="menuvscontent" cols="*,100%" title="#lorsm.Menu_area#">
    </else>

    <if @debuglevel@ gt 0>
                <frameset id="left" rows="50%,*">
    </if>
    <else>
                <frameset id="left" rows="100%,*">
    </else>
                    <frame src="blank.html" id="menu" name="menu" frameborder="0" scrolling=auto title="#lorsm.Menu#">

                    <frameset id="DownLeftFrame" rows="80%,*">
                        <frame src="blank.html" name="talk" frameborder="0">
                        <frame src="keepalive" name="keepalive" frameborder="0">
                    </frameset>
                </frameset>
                <frame src="blank-no-javascript.html" name="content" frameborder="0" scrolling=auto title="#lorsm.Contents#">
            </frameset>
        </frameset>
</html>
