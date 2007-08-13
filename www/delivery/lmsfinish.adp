
<HTML>
<HEAD>
<meta http-equiv=Content-Type content="text/html;  charset=ISO-8859-1">
<TITLE>SCORM FINISHER</TITLE>
<SCRIPT LANGUAGE="JavaScript">
var API = null;
<!--
// addition of backslash ahead of forward slash in closing SCRIPT tag
// for the benefit of NS 4x View Source and color coded software editors

if (navigator.appName && navigator.appName.indexOf("Microsoft") != -1 && 
	  navigator.userAgent.indexOf("Windows") != -1 && navigator.userAgent.indexOf("Windows 3.1") == -1) {
	document.write('<SCRIPT LANGUAGE=VBScript\> \n');
	document.write('on error resume next \n');
	document.write('Sub movie_FSCommand(ByVal command, ByVal args)\n');
	document.write('  call movie_DoFSCommand(command, args)\n');
	document.write('end sub\n');
	document.write('<\/SCRIPT\> \n');
}
// FS SCORM - fscommand adapter for ADL SCORM
// version 1.1.1    11/25/01      
// Copyright 2002 Pathlore Software Corporation All Rights Reserved
// Copyright 2002 Macromedia Inc. All rights reserved.
// Developed by Tom King, Macromedia and Leonard Greenberg, Pathlore
// Modified by Jeff Burton and Andrew Chemey, Macromedia (01/09/02)
// -----------------------------------------------------------------

var findAPITries = 0;
function findAPI(win)
{
   // Check to see if the window (win) contains the API
   // if the window (win) does not contain the API and
   // the window (win) has a parent window and the parent window  
   // is not the same as the window (win)
   while ( (win.API == null) && 
           (win.parent != null) && 
           (win.parent != win) )
   {	
      // increment the number of findAPITries
      findAPITries++;
      // Note: 7 is an arbitrary number, but should be more than sufficient
      if (findAPITries > 7) 
      {
         //alert("Error finding API -- too deeply nested.");
         return null;
      }
      
      // set the variable that represents the window being 
      // being searched to be the parent of the current window
      // then search for the API again
      win = win.parent;
   }
   return win.API;
}
function getAPI()
{
   // start by looking for the API in the current window
   var theAPI = findAPI(window);
   // if the API is null (could not be found in the current window)
   // and the current window has an opener window
   if ( (theAPI == null) && 
        (window.opener != null) && 
        (typeof(window.opener) != "undefined") )
   {
	
      // try to find the API in the current window's opener
      theAPI = findAPI(window.opener);
   }
   // if the API has not been found
   if (theAPI == null)
   {
      // Alert the user that the API Adapter could not be found
      //alert("Unable to find an API adapter");
   }
   return theAPI;
}

var API = getAPI();

document.write(API.LMSFinish(".LRN LMSFinish.adp calls finish"));
document.write("<BR><BR>");

var API=null;



//-->
</script>

</HEAD>

I will send you to:
the new item_id is @item_id@, while the old one is @initedonpage@

<script language="JavaScript">
<if @item_id@ gt 0>
location.replace("record-view?man_id=@man_id@&item_id=@item_id@&lmsfinish=1");
</if>
<else>
location.replace("body?man_id=@man_id@&lmsfinish=1");
</else>
</script>
</BODY>
</HTML>

