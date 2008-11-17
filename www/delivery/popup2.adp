<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">

<title>@course_name@</title>

<if @debuglevel@ gt 0>
    <frameset rows="100,100%" border=0 name="topcontainer">
</if>
<else>
    <frameset rows="*,100%" border=0 name="topcontainer">
</else>

        <frame src="blank-top.html" NAME="AppletContainerFrame" scrolling=no>
        <if @menu_off@ lt 1>
            <frameset cols="200,*" border=0 name="visible">
        </if>
        <else>
            <frameset cols="*,100%" frameborder=0 border=0 framespacing=0 name="visible">
        </else>

            <if @debuglevel@ gt 0>
                <frameset rows="50%,*" border=0 noresize border=0 frameborder=0 framespacing=0 "left">
            </if>
            <else>
                <frameset rows="100%,*" border=0 noresize border=0 frameborder=0 framespacing=0 name="left">
            </else>

                    <frame NAME=menu src="blank-menu.html" scrolling=no>
                    <frameset rows="100%,*" border=0 noresize border=0 frameborder=0 framespacing=0>
                        <frame src="blank.html" NAME="talk">
                        <frame src="keepalive" NAME="keepalive">
                    </frameset>
                </frameset>
                <frame NAME="content" src="blank.html" noresize border=0 scrolling=no>
            </frameset>
    </frameset>
<noframes></noframes>

