<head>
    <script type="text/javascript">
        debuglevel=@debuglevel@+0;
        ses_renew=@ses_renew@+0;
        menu_off=@menu_off@+0;
        exit_url="exit?man_id=@man_id@&track_id=@track_id@&return_url=@return_url@";
        return_url="@return_url@";
        main_body_url="body?man_id=@man_id@";
        content_url="<if @ims_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>";
        menu_url="@menu_type@?man_id=@man_id@&return_url=@return_url@<if @ims_id@ defined>&ims_id=@ims_id@</if>&track_id=@track_id@<if @menu_off@ defined>&menu_off=@menu_off@</if>";
        record_view_url="record-view?man_id=@man_id@&item_id=@item_id@";
    </script>
    <script type="text/javascript" SRC="applet.js"> </script>
</head>

<body BGCOLOR="#caffca" onload="return init();" onunload="return appletending();" >

<if @debuglevel@ gt 0>
    ses_renew: @ses_renew@
    ses_timeout: @ses_timeout@
    first_cookie: @cookie@
</if>

<applet code="org.adl.samplerte.client.APIAdapterApplet.class" archive="stuff.jar" width=@app_width@ height=@app_height@></xmp>
    <param name = "code" value = "org.adl.samplerte.client.APIAdapterApplet.class" >
    <param name = "type" value="application/x-java-applet">
    <param name = "JS" value="false">
    <param name = "cookie" value="@cookie@">
    <if @debuglevel@ gt 0>
        <param name = "debug" value="true">
    </if>
    <else>
        <param name = "debug" value="false">
    </else>
        <param name = "mayscript" value="true" >
        <param name = "scriptable" value="true" >
    <if @debuglevel@ gt 0>
        <param name = "archive" value = "stuff.jar?@random@" >
    </if>
    <else>
        <param name = "archive" value = "stuff.jar?@random@" >
    </else>
</applet>

</body>

