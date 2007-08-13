

function popitup(url,name) {
	if (!newwindow.closed && newwindow.location) {
		newwindow.location.href = url;
	}
	else {
		newwindow=window.open(url,name,'height=200,width=150');
		if (!newwindow.opener) newwindow.opener = self;
	}
	if (window.focus) {newwindow.focus()}
	if (!newwindow.focus) {newwindow.focus()}
	
	return false;
}


function popupnr(mylink, windowname, refocus)
{
var mywin, href, url, options;
windowname='LRN_delivery_window';
//alert(typeof(mylink));
if (typeof(mylink) == 'string')
   href=mylink+'';
else
   href=mylink.href+'';

options='location=no,status=no,toolbar=no,top,width=400,height=200,scrollbars=yes';
mywin = window.open(href, windowname, options);

try { url=mywin.document.URL;
	} catch (o) {
alert ('You need to remove popup blocker');
}

// if we just opened the window
if (
   mywin.closed || 
   (! mywin.document.URL) || 
   (mywin.document.URL.indexOf("about") == 0)
   )
   mywin.location=href;
else if (refocus)
   mywin.focus();
   
return false;

}
