<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">


<html>

<! onload="init();" ->

<head>

<title>@course_name@</title>
<SCRIPT LANGUAGE="javascript">
//<--!

this.releasemenu=null;
this.APIFinder=null;
this.initialized=false;
this.tries=0;
this.megatries=0;
this.bored=0;


function KeepAlive() {
        //number of seconds * 1000
        reloadtime=@ses_renew@*1000;
        myTimer=setTimeout("ReLoad()",reloadtime);
}

function ReLoad() {
   if( ! initialized ) { debug("deactivating keepalive");return; }
   debug("within reload()");
   var rnumb = Math.floor(Math.random()*999);
   temp = "keepalive?Rand="+rnumb;
   window.keepalive.document.location.href="blank.html";
   window.keepalive.document.location.replace("blank.html");
   window.keepalive.document.location.reload(true);
   window.keepalive.document.location.href=temp;
   window.keepalive.document.location.replace(temp);
   window.keepalive.document.location.reload(true);
   window.keepalive.document.src ="keepalive?Rand="+rnumb;
   KeepAlive();
}


function APIHolder() {
	//this is just a placeholder
}

function LMSInitialize(placeholder) {
	debug("<B>sco called LMSInitialize ("+placeholder+")</B>");
	initialized=APIFinder.LMSInitialize(placeholder);
	debug("<B>returning from LMSInitialize =("+initialized+")</B>");
	KeepAlive();
	debug("activating keepalive");
	return initialized;
}

function LMSFinish(placeholder) {
	debug("sco called LMSFinish("+placeholder+")");
	initialized=null;
	return APIFinder.LMSFinish(placeholder);
}

function LMSGetValue(name) {
	debug("sco called LMSGetValue("+name+")");
	return APIFinder.LMSGetValue(name);
}

function LMSCommit(placeholder) {
	debug("sco called LMSCommit("+placeholder+")");
	return APIFinder.LMSCommit(placeholder);
}

function LMSSetValue(name,value) {
	debug("sco called LMSSetValue("+name+","+value+")");
	return APIFinder.LMSSetValue(name,value);
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
		var temp=AppletContainerFrame.document.location.href;
		debug(temp);
		AppletContainerFrame.document.location.href="blank.html";
		AppletContainerFrame.document.location.replace("blank.html");
		AppletContainerFrame.document.location.reload(true);
		AppletContainerFrame.document.location.href=temp;
		AppletContainerFrame.document.location.replace(temp);
		AppletContainerFrame.document.location.reload(true);
       		debug("waiting again");
		tries=0; megatries++;
       		setTimeout("waitforapplet();",1000)
	}

	try {
			var active=AppletContainerFrame.document.applets[0].isActive(); //mozilla error on this, IE just gives out (doesnt' go in the catch ???)
		} catch (err) {
			try {
			var active=AppletContainerFrame.document.applets[0].isActive; //this is mozilla specific, IE is just allergic (we have enough wars not to think of browsers'....
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
	window.talk.document.write("<FONT SIZE=1>"+message+"<HR>");
	return;
	}

function init() {
    debug("inizio toplevel findapi");
    var findapplets =0 ;
    var numtest = 0;
    //frames['applet'].document.write("this is me");
    while ( findapplets != 1 && findapplets !=2 ) { //we use this weird setting not to have to set for typeof or undefined checking
 	findapplets=AppletContainerFrame.document.applets.length;
	debug(findapplets);
	numtest++;
	if (numtest>70) {
		debug("i cannot see the applet loading... is java enabled and installed ?");
		return(0);
	}
    }
    var findAPITries = 0;
    while (APIFinder == null) {
        //alert("dentro while");
        findAPITries++;
        APIFinder = AppletContainerFrame.document.applets[0]; // this returns object for opera and seems to be working
        // APIFinder = AppletContainerFrame.document.applets[1]; // this returns object for opera
        // APIFinder = AppletContainerFrame.document.applets['APIAdapter']; // this returns function for opera
        if (findAPITries > 70) {
            debug("FRAMESET Couldn't find the APIAdapter ");
		this.releasemenu=-1;
            break;
        }
    }
    if (findAPITries <=70) {
    	debug("Frameset FOUND API within applet (menu) - using APIfinder - loading learning object");
	this.releasemenu=1;
	applet.showmenu();
	//temporarly added for testing ADL conformance tests - which rely on typeof - miserably failing
	//alert(typeof(APIFinder.LMSInitialize)); 
	//alert(typeof(APIFinder.LMSGetLastError)); 
	API=new APIHolder();
	//alert(typeof(APIHolder)); 
	//alert(typeof(API)); 
	debug("the type of API.LMSInitialize is "+typeof(API.LMSInitialize)); 
	} else {
	debug("API not found, don't know what to do"); 
	}
	<if @menu_off@ lt 1>
    if (refreshFrame()==0) { 
	debug ("i would do reload now-- if for anything"); 
	//self.location.reload(); 
	}
	</if>
}

function closecontents() {
//alert("content going")
this.content.window.location.href = "blank.html";
if (this.content.window.location.href != "blank.htm") {
        setTimeout("closecontents();",1000)
        }
return(0);
}

function refreshFrame() {
//chiamata quando trovato adapter
frames['content'].window.location.href = "blank.html";
frames['content'].window.location.href = "<if @ims_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>";
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
	frames['content'].window.location.href = "blank.html";
	frames['content'].window.location.href = "<if @ims_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>";
        if (findgetAppletInfo> 7) {
            debug("I cannot talk to APIAdapter: try reloading me. Please notify support of your sw configuration ;) ");
            return(0);
        }
   }
   return(1);	
}

//-->
</SCRIPT>

</head>

<if @debuglevel@ gt 0>
<frameset rows="100,100%" border=0> 
</if>
<else>
<frameset rows="*,100%" border=0> 
</else>
<frame src="applet" name="AppletContainerFrame" scrolling=auto>

<if @menu_off@ lt 1>
<frameset cols="200,*" border=0 onload="waitforapplet();">
</if>
<else>
<frameset cols="*,100%" frameborder=0 border=0 framespacing=0 onload="waitforapplet();" name="page">
</else>
<if @debuglevel@ gt 0>
<frameset rows="50%,*" border=0 name="left" noresize border=0 frameborder=0 framespacing=0> 
</if>
<else>
<frameset rows="100%,*" border=0 name="left" noresize border=0 frameborder=0 framespacing=0> 
</else>
<frame src="menu?man_id=@man_id@<if @ims_id@ defined>&ims_id=@ims_id@</if>&track_id=@track_id@<if @menu_off@ defined>&menu_off=@menu_off@</if>" name="applet" scrolling=no>
<frameset rows="90%,*" border=0 name="DownLeftFrame" noresize border=0 frameborder=0 framespacing=0>
<frame src="blank.html" name="talk">
<frame src="keepalive" name="keepalive">
</frameset>
</frameset>
<frame src="blank.html" name="content" scrolling=auto>
</frameset>


</frameset>



</html>

