

this.releasemenu=null;
this.APIFinder=null;
this.initialized=false;
this.finished=false;
this.tries=0;
this.megatries=0;
this.bored=0;
this.finishing=false;

//this.withinfinish=false;
//this.withininitialize=false;

function debug(message) {
		if (debuglevel ==1) {
			if (menu_off < 1 ) {
					parent.frames['talk'].document.write("<FONT SIZE=1>"+message+"<HR>");
			}
		}
		return;
	}

function messaging(message) {
		if (debuglevel ==1) {
			try {
			parent.frames['content'].document.write(message);
			} catch (err) {
			debug("Messaging error.");
			}
		}
		return;
}


function BlurListener(evt) {
evt = evt || window.event;
//debug('blurlistener');
menu_frameset=parent.document.getElementById("menuvscontent");
menu_frameset.cols="5%,*";
menu_frame=parent.frames['menu'];
menu_frame.toggleBox('abort',0);
menu_frame.toggleBox('btn_finish',0);
}
				
function FocusListener(evt) {
evt = evt || window.event;
//debug('focuslistener');
menu_frameset=parent.document.getElementById("menuvscontent");
menu_frameset.cols="15%,*";
menu_frame=parent.frames['menu'];
menu_frame.toggleBox('abort',1);
menu_frame.toggleBox('btn_finish',1);
}

function appletending() {
   // try { 
	// selfcheck(); 
   // } catch (o) { 
	// debug(o); 
	// }
   self.document.location.href="blank.html";
   self.document.location.replace("blank.html");
   self.document.src="blank.html";
   self.document.write("TERMINATING");
   parent.API=null;
   APIFinder=null;
   APIHolder=null;
   API=null;   
   return(true);
}


// function selfcheck() {
	// alert(parent.window.name);
	// if ( parent.window.name=='LRN_delivery_window' ) {
		// parent.close();
		//alert('eeh');
	// }
// }

function KeepAlive() {
   	//number of seconds * 1000
	reloadtime=this.ses_renew*1000;
	myTimer=setTimeout("AliveReLoad()",reloadtime);
	debug("scheduling keepalive every "+reloadtime/1000+" seconds");
}

function AliveReLoad() {
   //keepalive will always be there: no more just initialized if( ! initialized ) { debug("deactivating keepalive");return; }
   debug("within AliveReload()");
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
		if (menu_off < 1 ) {
		message="<FONT SIZE=1>Server failure: Error in communication to server:<BR>"+APIFinder.LastServerError;
		parent.frames['menu'].writit(message,'usermessage');
		} else {
		debug("server error in keepalive");
		}
		APIFinder.LastServerError="";
	} else {
		if (menu_off < 1 ) {
		message="<FONT SIZE=1>Server online</FONT>";
		parent.frames['menu'].writit(message,'usermessage');
		} else {
		debug("server OK in keepalive");
		}
	}
   KeepAlive();
}

function BackToBody() {
		try {
			debug("doing backtobody");
			if (menu_off < 1 ) {
				parent.frames['menu'].writit('','abort');
				parent.frames['menu'].writit('','usermessage');
			}
			messaging("Unloading course");
			if (menu_off < 1) {
				parent.frames['content'].document.location.href = main_body_url;
			} else {
				top.document.location.href = return_url;		
			}
		} catch (err) {
			debug("<B>FAILURE calling backtobody FAILED</B>");
		}
		debug("<B>ending backtobody</B>");
		finishing=false;
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
//SUPERFLUO ??
if (menu_off < 1 ) {
		parent.frames['content'].window.location.href = "blank.html";
		parent.frames['content'].window.location.href = content_url;
}
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
	//NONO KeepAlive();
	if (menu_off < 1 ) {
		parent.frames['content'].document.location.href = "blank.html";
		parent.frames['content'].document.location.href = content_url;
		//let's show menu now
		parent.frames['menu'].window.location.href = menu_url;
		//obviously no menu if menu is off...
	} else {
	messaging("<FONT SIZE=2>Please wait. Loading contents.<BR>Attendere prego. Caricamento contenuti.<BR>");
	parent.frames['content'].location.href = record_view_url;
	}
        if (findgetAppletInfo> 7) {
            debug("I cannot talk to APIAdapter: try reloading me. Please notify support of your sw configuration ;) ");
            return(0);
        }
   }
   return(1);	
}



function APIHolder() {
	//this is just a placeholder
}

function LMSInitialize(placeholder) {	
	debug("<B>sco called LMSInitialize ("+placeholder+")</B>");
	initialized=APIFinder.LMSInitialize(placeholder);
	debug("<B>returning from LMSInitialize =("+initialized+")</B>");
	initialized=initialized+'';
	if(initialized=='true') {
		if (menu_off < 1 ) {
		menu_frame=parent.frames['menu'];
		menu_frameset=parent.document.getElementById("menuvscontent");
		
		menu_x=parent.document.getElementById("left");
		menu_x.onmouseover = FocusListener;
		menu_x.onmouseout = BlurListener;

		menu_frame.toggleBox('menudiv',0);
		menu_frame.toggleBox('abort',0);
		menu_frame.toggleBox('btn_finish',0);
		
		menu_frameset.cols="5%,*";
		menu_frame.writit('<FONT SIZE=1>EXIT</FONT><BR>','usermessage');
		menu_frame.writit('<a href=\"'+exit_url+'\"  style=\"display: block; \" class=\"button\" target=\"_top\"><B>Abort</B> Course <BR>(clicking this will not record tracking information)</a>','abort');
		menu_frame.writit('<a href=\"'+main_body_url+'\"  style=\"display: block; \" class=\"button\" target=\"content\"><B>Close</B> Unit <BR>(force LMSFinish)</a>','btn_finish');	
		}
		APIFinder.LastServerError="";
	} else {
		if (menu_off < 1 ) {
		message="<FONT SIZE=3>LMSInitialize: Error in communication to server:</FONT><BR><FONT SIZE=1>"+APIFinder.LastServerError+"</FONT>";
		parent.frames['menu'].writit(message,'usermessage');
		} else {
		debug("server error in LMSInitialize");
		}
	}
	return initialized+'';
}

function LMSFinish(placeholder) {
	if (menu_off < 1 ) {
		menu_frame=parent.frames['menu'];
		
		menu_x=parent.document.getElementById("left");
		menu_x.onmouseover = '';
		menu_x.onmouseout = '';

		menu_frameset=parent.document.getElementById("menuvscontent");
		menu_frameset.cols="40%,*";
		//stupid reload trick
		//this reloads menu, showing us the beauty of realtime lesson_status changes
		//but screws up applet init ?
		tempvar=parent.frames['menu'].location.href;
		dummyDate = new Date() ; 
		dummyParameter = "&" + dummyDate.getTime()
		parent.frames['menu'].location.href = tempvar + dummyParameter
	}
	if(!(initialized=='true')) {
		debug("SCO called LMSFinish ("+placeholder+") but course not initialized");
		return false;
	}
	finishing=true;
	if (menu_off < 1 ) {
		parent.frames['menu'].writit('<FONT SIZE=1>Sending tracking to server....</FONT>','usermessage');
	}
	debug("APPLET.JS sco called LMSFinish("+placeholder+")");
	debug("<B>calling LMSfinish =(\'\')</B>");
	// Make sure param is empty string "" - as per the API spec
    finished=APIFinder.LMSFinish('');
	finished=finished+'';
	debug("<B>returning from LMSfinish =("+finished+")</B>");
	//now we schedule a page unload AFTER the course has received the LMSFINISH ok
	if(finished=='true') {
		//we set initialized to false ONLY when finished has been processed
		//it could be some courses try finish more than once following an error
		initialized=false;
		debug('Within finish, before backtobody timeout');
		myTimer=setTimeout("BackToBody()",1000)
		debug('Within finish, past backtobody timeout setting');
		APIFinder.LastServerError="";
		if (menu_off < 1 ) {
			try {

				parent.frames['menu'].writit('','abort');
				parent.frames['menu'].writit('','btn_finish');
				parent.frames['menu'].toggleBox('menudiv',1);
				parent.frames['menu'].writit('<FONT SIZE=1>Tracking is OK</FONT>','usermessage');
			} catch (err) {
				debug ("cannot restore menu... what's up ?")
			}
		}
	} else {
		//Some error occourred. not clear at this stage if SERVER SIDE or what
		finishing=false;
		if (menu_off < 1 ) {
		//better be conservative. don't give'em menu back
		//parent.frames['menu'].writit('','abort');
		//parent.frames['menu'].toggleBox('menudiv',1);
		message="<FONT SIZE=3>LMSFinish: Error in communication to server:</FONT><BR><FONT SIZE=1>"+APIFinder.LastServerError+"</FONT>";
		parent.frames['menu'].writit(message,'usermessage');
		} else {
		debug("ERROR during LMSFinish CALL !!!");
		}
	}
	return finished;
}

function LMSGetValue(name) {
	if(!(initialized=='true')) {
		debug("LMSGetValue: damn SCO called LMSGetValue("+name+") but course not initialized");
		debug("LMSGetValue: we try calling initialization ourselves");
		var temp=API.LMSInitialize('');
		debug("LMSGetValue: initialization was="+temp);
	}
	debug("sco called LMSGetValue("+name+")");
	getvalue=APIFinder.LMSGetValue(name);
	getvalue=getvalue+'';
	debug("LMSGetValue("+name+") returns ("+getvalue+")");
	return(getvalue); 
}

function LMSCommit(placeholder) {
	if(!(initialized=='true')) {
		debug("LMSCommit: damn SCO called LMSGetValue("+name+") but course not initialized");
		debug("LMSCommit: we try calling initialization ourselves");
		var temp=API.LMSInitialize('');
		debug("LMSCommit: initialization was="+temp);
	}
	debug("sco called LMSCommit("+placeholder+")");
	committed=APIFinder.LMSCommit(placeholder);
	committed=committed+'';
	if(!(committed=='true')) {
		if (menu_off < 1 ) {
		message="<FONT SIZE=3>Commit: Error in communication to server:</FONT><BR><FONT SIZE=1>"+APIFinder.LastServerError+"</FONT>";
		parent.frames['menu'].writit(message,'usermessage');
		} else {
		debug("ERROR during LMSCommit CALL !!!");
		}
	} else {
		if (menu_off < 1 ) {
		parent.frames['menu'].writit('<FONT SIZE=1>Committed OK</FONT>','usermessage');
		}
		APIFinder.LastServerError="";
	}
	return committed;
}

function LMSSetValue(name,value) {
	if(!(initialized=='true')) {
		debug("LMSSetValue: damn SCO called LMSGetValue("+name+") but course not initialized");
		debug("LMSSetValue: we try calling initialization ourselves");
		var temp=API.LMSInitialize('');
		debug("LMSSetValue: initialization was="+temp);
	}
	debug("sco called LMSSetValue("+name+","+value+")");
	setvalue=APIFinder.LMSSetValue(name,value);
	setvalue=setvalue+'';
	debug("LMSsetvalue returning "+setvalue+" ");
	return (setvalue);
}

function LMSGetLastError()	{debug ("sco called LMSGetLastError ("+")"); return APIFinder.LMSGetLastError()+''}
function LMSGetErrorString(number)	{debug ("sco called LMSGetErrorString ("+number+")"); return APIFinder.LMSGetErrorString(number)+''}
function LMSGetDiagnostic(placeholder)	{debug ("sco called LMSGetDiagnostic ("+placeholder+")"); return APIFinder.LMSGetDiagnostic(placeholder)+''}

APIHolder.prototype.LMSInitialize=LMSInitialize;
APIHolder.prototype.LMSFinish=LMSFinish;
APIHolder.prototype.LMSGetValue=LMSGetValue;
APIHolder.prototype.LMSCommit=LMSCommit;
APIHolder.prototype.LMSSetValue=LMSSetValue;
APIHolder.prototype.LMSGetLastError=LMSGetLastError;
APIHolder.prototype.LMSGetErrorString=LMSGetErrorString;
APIHolder.prototype.LMSGetDiagnostic=LMSGetDiagnostic;


