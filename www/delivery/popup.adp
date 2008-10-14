<HEAD>
<if @menu_off@ gt 0>
<link rel="stylesheet" type="text/css" href="scorm.css" media="all">
</if>
<SCRIPT type="text/javascript">
//<--!

this.releasemenu=null;
this.APIFinder=null;
this.initialized=false;
this.finished=false;
this.tries=0;
this.megatries=0;
this.bored=0;
var childwindow=null;
var debugwindow=null;
this.childclosed=false;
this.childwindow=1;
var W=1024;
var H=768;
var moved=false;


function mouser() {

	if(!this.childwindow) {
		debug("child not there (childclosed is="+this.childclosed);
		if(this.childclosed==false) {
			debug("popup blocked or not yet coming");
		} else {
			debug("popup closed");
		}
	} else {
		if(childwindow.closed) {
			moveaway();
		}
		debug("child is there (childclosed is="+this.childclosed);
		debug("child is there (closed property is="+childwindow.closed);
		try{
			this.childwindow.focus();
		} catch (err) {
			debug("can't focus! in mouser");
		}
	}
	if(moved) {
	self.location="@return_url@";
	}

}

function moveaway() {
	if(! childwindow.closed) {
   		myTimer=setTimeout("moveaway()",2500)
	} else {
		self.document.write("Back to class.");
		moved=true;
		try{
		window.resizeTo(W+20,H+100); 
		} catch (err) {
		window.resizeTo(800,600);
		}
		self.location="@return_url@";
		//self.history.go(-2);
	}
}

function debug(message) {
	//childwindow.frames['talk'].document.write(message+"<HR>");
	<if @debuglevel@ gt 0>
		try {
		this.debugwindow.document.write(message+"<HR>");
		} catch (err)  {
			//cosa fare qui 
		}
	</if>
	<else>
	var myx=0;
	</else>
	return;
	}


function getSize() {
  var myWidth = 0, myHeight = 0;
  if( typeof( window.innerWidth ) == 'number' ) {
    //Non-IE
    myWidth = window.innerWidth;
    myHeight = window.innerHeight;
  } else if( document.documentElement &&
      ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
    //IE 6+ in 'standards compliant mode'
    myWidth = document.documentElement.clientWidth;
    myHeight = document.documentElement.clientHeight;
  } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
    //IE 4 compatible
    myWidth = document.body.clientWidth;
    myHeight = document.body.clientHeight;
  }
  W=myWidth;
  H=myHeight;
}


function EndingNow() {
   APIFinder.stop();
   APIFinder.destroy();
   APIHolder=null;
   API=null;
   this.childwindow.location.href="blank.html";
   this.childwindow.location.replace("blank.html");
   this.childwindow.location.reload(true);
   this.location.href="blank.html";
   this.location.replace("blank.html");
   this.location.reload(true);
   return;
}

function KeepAlive() {
        //number of seconds * 1000
        reloadtime=@ses_renew@*1000;
        //testing
	//reloadtime=@ses_renew@*50;
        myTimer=setTimeout("ReLoad()",reloadtime);
        debug("scheduling keepalive every "+reloadtime/1000+" seconds");
}

function ReLoad() {
   //keepalive will always be there: no more just initialized if( ! initialized ) { debug("deactivating keepalive");return; }
   debug("within reload()");
   var rnumb = Math.floor(Math.random()*999);
   temp = "keepalive?Rand="+rnumb;
   childwindow.frames['keepalive'].location.href="blank.html";
   childwindow.frames['keepalive'].document.location.replace("blank.html");
   childwindow.frames['keepalive'].document.location.reload(true);
   childwindow.frames['keepalive'].document.location.href=temp;
   childwindow.frames['keepalive'].document.location.replace(temp);
   childwindow.frames['keepalive'].document.location.reload(true);
   childwindow.frames['keepalive'].document.src ="keepalive?Rand="+rnumb;
   if(!APIFinder.KeepAlive()) {
        //gestione errore di KeepAlive dell'applet.
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
	return initialized;
}


function LMSFinish(placeholder) {
	//window.resizeTo(this.w,this.h);
	debug("sco called LMSFinish("+placeholder+")");
	initialized=null;
	finished=APIFinder.LMSFinish(placeholder);
	debug("<B>returning from LMSfinish =("+finished+")</B>");
	return finished;
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

function popit(name,url,wid,hgt,lt,tp) {  
	//window[name] = open(url,name,'width='+wid+',height='+hgt+',left='+lt+',top='+tp+',status,menubar=no,resizable=no,scrollbars=no,AlwaysRaised=1');  
	mywin = open(url,name,'width='+wid+',height='+hgt+',left='+lt+',top='+tp+',status,menubar=no,resizable=no,scrollbars=no,AlwaysRaised=1');  
	if (mywin & !mywin.closed) mywin.focus(); 
	return(mywin);
}  


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

function init() {
    this.childwindow=popit('popup','popup2?man_id=@man_id@<if @ims_item_id@ defined>&ims_id=@ims_item_id@</if>&track_id=@track_id@<if @menu_off@ defined>&menu_off=@menu_off@</if> ',810,540,20,20);
    <if @debuglevel@ gt 0>
    this.debugwindow=popit('debuggerwindow','blank.html',210,640,10,10);
    </if>
    z=0; 
    while((childwindow.document)==null ) {
	debug("waiting for child");
	z=z+1;
	if(z>10000) {
		alert("enable popups");
		history.go(-1);
	}
    }
    debug("inizio toplevel findapi");
    var findapplets =0 ;
    var numtest = 0;
    //frames['menu'].document.write("this is me");
    while ( findapplets != 1 && findapplets !=2 ) { //we use this weird setting not to have to set for typeof or undefined checking
 	findapplets=this.document.applets.length;
	debug(findapplets);
	numtest++;
	if (numtest>70) {
		childwindow.document.write("Please install java version 1.4.x or 1.5.x. Also check your firewall policies.");
		debug("i cannot see the applet loading... is java enabled and installed ?");
   		myTimer=setTimeout("childwindow.close()",5000);
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
		this.releasemenu=-1;
            break;
        }
    }
    if (findAPITries <=70) {
    	debug("Frameset FOUND API within applet (menu) - using APIfinder - loading learning object");
	this.releasemenu=1;
	//this should be fixed. it's browser specific so we comment it out
	//childwindow.frames['applet'].showmenu();
	//temporarly added for testing ADL conformance tests - which rely on typeof - miserably failing
	//alert(typeof(APIFinder.LMSInitialize)); 
	//alert(typeof(APIFinder.LMSGetLastError)); 
	API=new APIHolder();
	//exporting API to childwindow
	childwindow.API=this.API;
	//alert(typeof(APIHolder)); 
	//alert(typeof(API)); 
	debug("the type of API.LMSInitialize is "+typeof(API.LMSInitialize)); 
	} else {
	debug("API not found, don't know what to do"); 
	}
	//here we had a menu off switch
        if (refreshFrame()==0) { 
		debug ("i would do reload now-- if for anything"); 
		//self.location.reload(); 
		childwindow.focus();
	}
	//here the menu off switch would end
}

//function closecontents() {
//alert("content going")
//childwindow.frames['content'].window.location.href = "blank.html";
//if (childwindow.frames['content'].window.location.href != "blank.htm") {
//        setTimeout("closecontents();",1000)
//        }
//return(0);
//}


function checkAll() {
          var innerDocument = childwindow.frames;
          for (var i=0;i<innerDocument.elements;i++) {
            var e = innerDocument.elements[i];
                debug(e.type);
          }
	  debug(i);
   } 


function refreshFrame() {
//chiamata quando trovato adapter
<if @menu_off@ lt 1>
childwindow.frames['content'].window.location.href = "blank.html";
childwindow.frames['content'].window.location.href = "<if @ims_item_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>";
</if>
//not ready yet to show menu
//debug(typeof(this.childwindow));
//debug(typeof(this.childwindow.frames['topcontainer']));
debug("frames:");
checkAll();
debug("end of frames:");
//debug(childwindow.frames['topcontainer']);
//debug(childwindow.frames['menu'].document.write("aagh"));
//childwindow.frames['menu'].window.location.href = "blank.html";
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
	childwindow.frames['content'].document.location.href = "blank.html";
	childwindow.frames['content'].document.location.href = "<if @ims_item_id@ defined>@body_url;noquote@</if><else>body?man_id=@man_id@</else>";
	//let's show menu now
	childwindow.frames['menu'].document.location.href = "menu?man_id=@man_id@<if @ims_item_id@ defined>&ims_id=@ims_item_id@</if>&track_id=@track_id@<if @menu_off@ defined>&menu_off=@menu_off@</if>";
	//obviously no menu if menu is off...
	</if>
	<else>
	try {
	childwindow.frames['content'].document.write("Please wait. Loading contents.<BR>")
	} catch (err) {
		//we are on a slow browser somehow
		//or something has gotten really wrong
		debug("waiting for childwindow to come up");
   		myTimer=setTimeout("refreshFrame()",2500);
		return(0);
	}
	childwindow.frames['content'].document.location.href = "record-view?man_id=@man_id@&item_id=@ims_item_id@";
	childwindow.caller=self;
	childwindow.focus();
	debug("calling @man_id@ with @ims_item_id@");
	</else>
        if (findgetAppletInfo> 7) {
            debug("I cannot talk to APIAdapter: try reloading me. Please notify support of your sw configuration ;) ");
            return(0);
        }
   }
   getSize();
   window.resizeTo(450,450);
   return(1);	
}

//-->
</SCRIPT>

</HEAD>

<BODY onload="init();" onmouseover="mouser();"> 

<if @debuglevel@ gt 0>
@cookie@
</if>
<else>
This window is a placeholder. Course contents should load in a new window.<BR> 
Please don't close this window. <BR>
</else>

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

