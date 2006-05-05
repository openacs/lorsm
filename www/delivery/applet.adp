<HEAD>

<SCRIPT LANGUAGE="javascript">
//<--!

this.releasemenu=null;
this.APIFinder=null;
this.initialized=false;
this.finished=false;
this.tries=0;
this.megatries=0;
this.bored=0;
this.finishing=false;
this.withinfinish=false;
this.withininitialize=false;


function EndingNow() {
	//UNLOADING APPLET
	//alert("APPLET UNLOADING");
   //this.parent.location.href="blank.html";
   //this.parent.location.replace("blank.html");
   //this.parent.location.reload(true);
   self.document.location.href="blank.html";
   self.document.location.replace("blank.html");
   self.document.src="blank.html";
   self.document.write("TERMINATING");
   //self.document.location.reload(true);
   //APIFinder.stop();
   //APIFinder.destroy();
   parent.API=null;
   APIFinder=null;
   APIHolder=null;
   API=null;
   return(true);
}

function KeepAlive() {
   	//number of seconds * 1000
	reloadtime=@ses_renew@*1000;
	myTimer=setTimeout("ReLoad()",reloadtime);
	debug("scheduling keepalive every "+reloadtime/1000+" seconds");
}

function ReLoad() {
   //keepalive will always be there: no more just initialized if( ! initialized ) { debug("deactivating keepalive");return; }
   debug("within reload()");
   var rnumb = Math.floor(Math.random()*999);
   temp = "keepalive?Rand="+rnumb;
   parent.frames['keepalive'].location.href="blank.html";
   parent.frames['keepalive'].document.location.replace("blank.html");
   parent.frames['keepalive'].document.location.reload(true);
   parent.frames['keepalive'].document.location.href=temp;
   parent.frames['keepalive'].document.location.replace(temp);
   parent.frames['keepalive'].document.location.reload(true);
   parent.frames['keepalive'].document.src ="keepalive?Rand="+rnumb;
   isalive=APIFinder.KeepAlive();
   if(!(isalive=='true')) {
		<if @menu_off@ lt 1>
		message="<FONT SIZE=1>Server failure: Error in communication to server:<BR>"+APIFinder.LastServerError;
		parent.frames['menu'].writit(message,'usermessage');
		</if>
		<else>
		debug("server error in keepalive");
		</else>
		APIFinder.LastServerError="";
	} else {
		<if @menu_off@ lt 1>
		message="<FONT SIZE=1>Server online</FONT>";
		parent.frames['menu'].writit(message,'usermessage');
		</if>
		<else>
		debug("server OK in keepalive");
		</else>
	}
   KeepAlive();
}


function APIHolder() {
	//this is just a placeholder
}

function LMSInitialize(placeholder) {
	debug("<B>sco called LMSInitialize ("+placeholder+")</B>");
	initialized=APIFinder.LMSInitialize(placeholder);
	debug("<B>returning from LMSInitialize =("+initialized+")</B>");
	if(initialized=='true') {
		<if @menu_off@ lt 1>
		parent.frames['menu'].toggleBox('menudiv',0);
		parent.frames['menu'].writit('<FONT SIZE=1>Course initialized.<BR>The menu returns when you exit the module.</FONT><BR>','usermessage');
		parent.frames['menu'].writit('<a href=\"exit?man_id=@man_id@&track_id=@track_id@&return_url=@return_url@\"  style=\"display: block; position: fixed;\" class=\"button\" target=\"_top\"><B>Abort</B> Course <BR>(clicking this will not record tracking information)</a>','abort');
		</if>
		APIFinder.LastServerError="";
	} else {
		<if @menu_off@ lt 1>
		message="<FONT SIZE=3>LMSInitialize: Error in communication to server:</FONT><BR><FONT SIZE=1>"+APIFinder.LastServerError+"</FONT>";
		parent.frames['menu'].writit(message,'usermessage');
		</if>
		<else>
		debug("server error in LMSInitialize");
		</else>
	}
	return initialized;
}

function BackToBody() {
		try {
			debug("doing backtobody");
			<if @menu_off@ lt 1>
			parent.frames['menu'].writit('','abort');
			parent.frames['menu'].writit('','usermessage');
			</if>
			messaging("Unloading course");
			parent.frames['content'].document.location.href = "body?man_id=@man_id@";
		} catch (err) {
			debug("<B>FAILURE calling backtobody FAILED</B>");
		}
		debug("<B>ending backtobody</B>");
		finishing=false;
}

function LMSFinish(placeholder) {
	if(!(initialized=='true')) {
		debug("SCO called LMSFinish when NOT INITIALIZED!");
	}
	finishing=true;
	<if @menu_off@ lt 1>
	parent.frames['menu'].writit('<FONT SIZE=1>Sending tracking to server....</FONT>','usermessage');
	</if>
	debug("sco called LMSFinish("+placeholder+")");
	debug("<B>calling LMSfinish =("+finished+")</B>");
	finished=APIFinder.LMSFinish(placeholder);
	debug("<B>returning from LMSfinish =("+finished+")</B>");
	//now we schedule a page unload AFTER the course has received the LMSFINISH ok
	if(finished=='true') {
		//we set initialized to false ONLY when finished has been processed
		//it could be some courses try finish more than once following an error
		initialized=false;
		myTimer=setTimeout("BackToBody()",1000)
		APIFinder.LastserverError="";
		<if @menu_off@ lt 1>
		parent.frames['menu'].writit('','abort');
		parent.frames['menu'].toggleBox('menudiv',1);
		parent.frames['menu'].writit('<FONT SIZE=1>Tracking is OK</FONT>','usermessage');
		</if>
	} else {
		//Some error occourred. not clear at this stage if SERVER SIDE or what
		finishing=false;
		<if @menu_off@ lt 1>
		//better be conservative. don't give'em menu back
		//parent.frames['menu'].writit('','abort');
		//parent.frames['menu'].toggleBox('menudiv',1);
		message="<FONT SIZE=3>LMSFinish: Error in communication to server:</FONT><BR><FONT SIZE=1>"+APIFinder.LastServerError+"</FONT>";
		parent.frames['menu'].writit(message,'usermessage');
		</if>
		<else>
		debug("ERROR during LMSFinish CALL !!!");
		</else>
	}
	return finished;
}

function LMSGetValue(name) {
	debug("sco called LMSGetValue("+name+")");
	getvalue=APIFinder.LMSGetValue(name);
	debug("LMSGetValue("+name+") returns ("+getvalue+")");
	return(getvalue); 
}

function LMSCommit(placeholder) {
	debug("sco called LMSCommit("+placeholder+")");
	committed=APIFinder.LMSCommit(placeholder);
	if(!(committed=='true')) {
		<if @menu_off@ lt 1>
		message="<FONT SIZE=3>Commit: Error in communication to server:</FONT><BR><FONT SIZE=1>"+APIFinder.LastServerError+"</FONT>";
		parent.frames['menu'].writit(message,'usermessage');
		</if>
		<else>
		debug("ERROR during LMSCommit CALL !!!");
		</else>
	} else {
		<if @menu_off@ lt 1>
		parent.frames['menu'].writit('<FONT SIZE=1>Committed OK</FONT>','usermessage');
		</if>
		APIFinder.LastServerError="";
	}
	return committed;
}

function LMSSetValue(name,value) {
	debug("sco called LMSSetValue("+name+","+value+")");
	setvalue=APIFinder.LMSSetValue(name,value);
	debug("LMSsetvalue returning "+setvalue+" ");
	return (setvalue);
}

function LMSGetLastError()	{debug ("sco called LMSGetLastError ("+")"); return APIFinder.LMSGetLastError()}
function LMSGetErrorString(number)	{debug ("sco called LMSGetErrorString ("+number+")"); return APIFinder.LMSGetErrorString(number)}
function LMSGetDiagnostic(placeholder)	{debug ("sco called LMSGetDiagnostic ("+placeholder+")"); return APIFinder.LMSGetDiagnostic(placeholder)}


APIHolder.prototype.LMSInitialize=LMSInitialize;
APIHolder.prototype.LMSFinish=LMSFinish;
APIHolder.prototype.LMSGetValue=LMSGetValue;
APIHolder.prototype.LMSCommit=LMSCommit;
APIHolder.prototype.LMSSetValue=LMSSetValue;
APIHolder.prototype.LMSGetLastError=LMSGetLastError;
APIHolder.prototype.LMSGetErrorString=LMSGetErrorString;
APIHolder.prototype.LMSGetDiagnostic=LMSGetDiagnostic;


function waitforapplet() {
	debug("in waitforapplet");

	if (megatries>5) {
		debug("giving up");
		if(bored==0) {
		bored=1;
		alert("Your browser seems not to let me communicate with the applet. Please check:\n1) Java support is installed and active in the browser\n2)That your browser supports java-javascript connectivity (most versions of IE and Mozilla-compatible would be ok)\n3) If you are currentely installing Java support, please try again accesing the course after installation completion\n");
		}
		this.releasemenu=-1;
		return;
	}
	tries++;
	if (tries>3) {
		debug("bored with loading applet - trying something else");
		var temp=this.document.location.href;
		debug(temp);
		this.document.location.href="blank.html";
		this.document.location.replace("blank.html");
		this.document.location.reload(true);
		this.document.location.href=temp;
		this.document.location.replace(temp);
		this.document.location.reload(true);
       		debug("waiting again");
		tries=0; megatries++;
       		setTimeout("waitforapplet();",1000)
	}

	try {
			var active=this.document.applets[0].isActive(); //mozilla error on this, IE just gives out (doesnt' go in the catch ???)
		} catch (err) {
			try {
			var active=this.document.applets[0].isActive; //this is mozilla specific, IE is just allergic (we have enough wars not to think of browsers'....
			} catch (err2) {
				debug("applet not loaded within old explorer")
				debug("seems java is not installed")
			}
		}
 
	if (active) 
	{
	 debug("applet detected to be active");
         init();
         }
	   else {
       debug("applet results not active right now");
       setTimeout("waitforapplet();",1000)
       }
}

function debug(message) {
<if @menu_off@ lt 1>
	parent.frames['talk'].document.write("<FONT SIZE=1>"+message+"<HR>");
</if>
	return;
	}

function messaging(message) {
		try {
		parent.frames['content'].document.write(message);
		} catch (err) {
		debug("Messaging error.");
		}
		return;
}


function init() {
    debug("inizio toplevel findapi");
    messaging("Checking system configuration");
    var findapplets =0 ;
    var numtest = 0;
    //frames['menu'].document.write("this is me");
    while ( findapplets != 1 && findapplets !=2 ) { //we use this weird setting not to have to set for typeof or undefined checking
 	findapplets=this.document.applets.length;
	debug(findapplets);
	numtest++;
	if (numtest>70) {
		debug("i cannot see the applet loading... is java enabled and installed ?");
		messaging("Java JRE not found (error 206). Please check requirements.");
		return(0);
	}
    }
    var findAPITries = 0;
    while (APIFinder == null) {
        debug("whithin APIFinder while loop");
        findAPITries++;
        APIFinder = this.document.applets[0]; // this returns object for opera and seems to be working
        // APIFinder = this.document.applets[1]; // this returns object for opera
        // APIFinder = this.document.applets['APIAdapter']; // this returns function for opera
        if (findAPITries > 70) {
            debug("FRAMESET Couldn't find the APIAdapter ");
		messaging("Java JRE not found (error 223). Please check requirements.");
		this.releasemenu=-1;
            break;
        }
    }
    if (findAPITries <=70) {
    	debug("Frameset FOUND API within applet (menu) - using APIfinder - loading learning object");
	this.releasemenu=1;
	messaging("System check passed");
	//temporarly added for testing ADL conformance tests - which rely on typeof - miserably failing
	//alert(typeof(APIFinder.LMSInitialize)); 
	API=new APIHolder();
	//exporting API to parent
	parent.API=this.API;
	//alert(typeof(API)); 
	debug("the type of API.LMSInitialize is "+typeof(API.LMSInitialize)); 
	} else {
	debug("API not found, don't know what to do"); 
	}
	//here we had a menu off switch
    		if (refreshFrame()==0) { 
		debug ("i would do reload now-- if for anything"); 
		messaging("Double checking system configuration.");
		//alert("reload1");
		self.location.reload(); 
	}
	//here the menu off switch would end
}

//function closecontents() {
//alert("content going")
//parent.frames['content'].window.location.href = "blank.html";
//if (parent.frames['content'].window.location.href != "blank.htm") {
//        setTimeout("closecontents();",1000)
//        }
//return(0);
//}

function refreshFrame() {
//chiamata quando trovato adapter
<if @menu_off@ lt 1>
parent.frames['content'].window.location.href = "blank.html";
parent.frames['content'].window.location.href = "<if @ims_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>";
</if>
//not ready yet to show menu
parent.frames['menu'].window.location.href = "blank.html";
var gotit=null;
var findgetAppletInfo = 0;
   while(gotit == null) {
	debug("tipo di API (via APIfinder):"+typeof(APIFinder));
        findgetAppletInfo++;
	try {
	gotit=APIFinder.getAppletInfo();
	debug("we have established communication from javascript to java:");
	debug(gotit);
	}
	catch (err) {
	debug("Your browser told me the applet was ready but now denies access to its functions, claiming \n"+err+"\n I must force reload, this way you won't see this message again, luckily.\n");
	return(0);
	}
	debug("activating keepalive");
	KeepAlive();
	<if @menu_off@ lt 1>
	parent.frames['content'].document.location.href = "blank.html";
	parent.frames['content'].document.location.href = "<if @ims_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>";
	//let's show menu now
	parent.frames['menu'].window.location.href = "menu?man_id=@man_id@&return_url=@return_url@<if @ims_id@ defined>&ims_id=@ims_id@</if>&track_id=@track_id@<if @menu_off@ defined>&menu_off=@menu_off@</if>";
	//obviously no menu if menu is off...
	</if>
	<else>
	messaging("<FONT SIZE=2>Please wait. Loading contents.<BR>Attendere prego. Caricamento contenuti.<BR>");
	parent.frames['content'].location.href = "record-view?man_id=@man_id@&item_id=@item_id@";
	</else>
        if (findgetAppletInfo> 7) {
            debug("I cannot talk to APIAdapter: try reloading me. Please notify support of your sw configuration ;) ");
            return(0);
        }
   }
   return(1);	
}

//-->
</SCRIPT>

</HEAD>

<BODY onload="return init();" onunload="EndingNow(); return;" > 

<if @debuglevel@ gt 0>
ses_renew: @ses_renew@
ses_timeout: @ses_timeout@
first_cookie: @cookie@
</if>

<SCRIPT LANGUAGE="JavaScript">
<!--
    var _info = navigator.userAgent; var _ns = false;
    var _ie = (_info.indexOf("MSIE") > 0 && _info.indexOf("Win") > 0 && _info.indexOf("Windows 3.1") < 0);
//-->
</SCRIPT>
<COMMENT>
<SCRIPT LANGUAGE="JavaScript1.1">
<!--
    var _ns = (navigator.appName.indexOf("Netscape") >= 0 && ((_info.indexOf("Win") > 0 && _info.indexOf("Win16") < 0 && java.lang.System.getProperty("os.version").indexOf("3.5") < 0) || (_info.indexOf("Sun") > 0) || (_info.indexOf("Linux") > 0)));
//-->
</SCRIPT>
</COMMENT>

<SCRIPT LANGUAGE="JavaScript">
<!--
    if (_ie == true) document.writeln('<OBJECT classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93" WIDTH=@app_width@ HEIGHT=@app_height@ codebase="http://java.sun.com/products/plugin/autodl/jinstall-1_4-windows-i586.cab#Version=1,4,0,0"><NOEMBED><XMP>');
    else if (_ns == true) document.writeln('<EMBED type="application/x-java-applet;version=1.4" java_CODE = "AppletButton.class" java_ARCHIVE = "stuff.jar" WIDTH=@app_width@ HEIGHT=@app_height@   pluginspage="http://java.sun.com/products/plugin/1.4.2/plugin-install.html"><NOEMBED><XMP>');
//-->
</SCRIPT>

<applet code="org.adl.samplerte.client.APIAdapterApplet.class" archive="stuff.jar" width=@app_width@ height=@app_height@></xmp>
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
<if @debuglevel@ gt 0>
  <param name = "archive" value = "stuff.jar?@random@" >
</if>
<else>
  <param name = "archive" value = "stuff.jar?@random@" >
</else>
</APPLET>

</NOEMBED></EMBED></OBJECT>


<!--
<applet code="org.adl.samplerte.client.APIAdapterApplet.class" MAYSCRIPT
<if @debuglevel@ gt 0>
            archive="stuff.jar?@random@"
</if>
<else>
            archive="stuff.jar"
</else>
            scriptable="true"
            id="APIAdapter"
            JS="false"
	    cookie="@cookie@"
<if @debuglevel@ gt 0>
            debug="true"
</if>
<else>
            debug="false"
</else>
            width=@app_width@
            height=@app_height@
            name="APIAdapter">
</APPLET>
-->
<!--"END_CONVERTED_APPLET"-->
</body>

