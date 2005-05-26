<body>

<if @debuglevel@ gt 0>
<PRE>
DEBUG MODE ON. THIS IS APPLET.ADP<BR>
@cookie@<BR>
<HR>
</if>

<object classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93"
<if @debuglevel@ gt 0>
   width="150" height="150" id="APIAdapter"
</if>
<else>
   width="0" height="0" id="APIAdapter"
</else>
   codebase="http://java.sun.com/products/plugin/autodl/jinstall-1_4-windows-i586.cab#Version=1,4,0,0">
  <param name = "code" value = "org.adl.samplerte.client.APIAdapterApplet.class" >
  <param name = "type" value="application/x-java-applet;jpi-version=1.4.2">
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
  <param name = "archive" value = "stuff.jar" >

<comment>
this is a comment
</comment>

  <applet code="org.adl.samplerte.client.APIAdapterApplet.class" MAYSCRIPT
            archive="stuff.jar"
            scriptable="true"
            id="APIAdapter"
            JS="false"
	    cookie="@cookie@"
<if @debuglevel@ gt 0>
            debug="true"
            height="150"
            width="150"
</if>
<else>
            debug="false"
            height="0"
            width="0"
</else>
            name="APIAdapter">
</applet>
</object>



</body>

