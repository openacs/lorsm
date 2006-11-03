<html>
<head>
<title>#lorsm.Menu#</title>

<link rel="stylesheet" type="text/css" href="scorm.css" media="all">


<script language="JavaScript" src="tigra/tree.js"></script>
<script language="JavaScript">
//<!--

var menu=null;
var API;
ns4 = (document.layers)? true:false;
ie4 = (document.all)? true:false;

//function onunload() {
//alert("unloading me");
//z=parent.closecontents();
//if (this.parent.content.window.location.href != "blank.htm") {
// 	setTimeout("onunload();",1000)
//	}
//}

function init() {
    API = this.document.APIAdapter;
    debug("before systemcheck");
    z=systemcheck();
    debug("after systemcheck");
    try {
	if(self.parent.window.frames['AppletContainerFrame'].initialized) {
	this.toggleBox('menudiv',0);
	} else {
	debug("normal");
	}
	} catch (err) {
		debug("applet not available in menu.init();");
	}
    //document.applets[0].init();
    //alert("JAVA-JAVASCRIPT: i've inited myself");
}


function writit(text,id)
{
	if (document.getElementById) //Gecko IE5+
	{
		x = document.getElementById(id);
		x.innerHTML = '';
		x.innerHTML = text;
	}
	else if (document.all) // IE 4
	{
		x = document.all[id];
		x.innerHTML = text;
	}
	else if (document.layers) //NN4+
	{
		x = document.layers[id];
		text2 = '<P CLASS="testclass">' + text + '</P>';
		x.document.open();
		x.document.write(text2);
		x.document.close();
	}
}


function toggleBox(szDivID, iState) // 1 visible, 0 hidden
{
    if(document.layers)	   //NN4+
    {
       document.layers[szDivID].visibility = iState ? "show" : "hide";
    }
    else if(document.getElementById)	  //gecko(NN6) + IE 5+
    {
        var obj = document.getElementById(szDivID);
        obj.style.visibility = iState ? "visible" : "hidden";
    }
    else if(document.all)	// IE 4
    {
        document.all[szDivID].style.visibility = iState ? "visible" : "hidden";
    }
}


function show(id) {
        if (ns4) document.layers[id].visibility="view";
 	if (ie4) document.all[id].style.visibility = "visible";
}

function hide(id) {
	if (ns4) document.layers[id].visibility = "hide";
    	if (ie4) document.all[id].style.visibility = "hidden";
}

function changeSCOContent() {
    alert("LMSFINISH completing: getting out on JAVA APPLET request");
    parent.window.location.href = "@return_url@";
    return 1;
}

function showmenu() {
	debug("within showmenu");
    	//if(isNull(document.getElementById("treemenu").style.display)) {
		debug("showmenu is null !!!");
	//} else {
		debug("not showing");
		//NON SUPPORTATO IN IE5.01
    		//document.getElementById("treemenu").style.display='block';
	//}
}

function showcontent() {
	parent.frames['content'].location.href = "record-view?man_id=@man_id@&item_id=@ims_item_id@";
}

function closeme() {
	parent.window.close();
}

function getCookie(name)
{
    var dc = document.cookie;
    var prefix = name + "=";
    var begin = dc.indexOf("; " + prefix);
    if (begin == -1)
    {
        begin = dc.indexOf(prefix);
        if (begin != 0) return null;
    }
    else
    {
        begin += 2;
    }
    var end = document.cookie.indexOf(";", begin);
    if (end == -1)
    {
        end = dc.length;
    }
    return (name+"="+unescape(dc.substring(begin + prefix.length, end)).replace("+"," ").replace("+"," ").replace("+"," ").replace("+"," "));
}

//MOVED HERE 

var TREE_ITEMS = [['Course Index', 'body?man_id=@man_id@',

<if @TREE_ITEMS@ defined>@TREE_ITEMS;noquote@</if>

]];

<if @TREE_HASH@ defined>
var TREE_HASH = new Array();
@TREE_HASH;noquote@
</if>

var tree_tpl = {
	'target'  : 'content',	// name of the frame links will be opened in

	'icon_e'  : 'tigra/demo1/icons/empty.gif', // empty image
	'icon_l'  : 'tigra/demo1/icons/line.gif',  // vertical line

        'icon_32' : 'tigra/demo1/icons/base.gif',   // root leaf icon normal
        'icon_36' : 'tigra/demo1/icons/base.gif',   // root leaf icon selected

	'icon_48' : 'tigra/demo1/icons/base.gif',   // root icon normal
	'icon_52' : 'tigra/demo1/icons/base.gif',   // root icon selected
	'icon_56' : 'tigra/demo1/icons/base.gif',   // root icon opened
	'icon_60' : 'tigra/demo1/icons/base.gif',   // root icon selected
	
	'icon_16' : 'tigra/demo1/icons/folder.gif', // node icon normal
	'icon_20' : 'tigra/demo1/icons/folderopen.gif', // node icon selected
	'icon_24' : 'tigra/demo1/icons/folderopen.gif', // node icon opened
	'icon_28' : 'tigra/demo1/icons/folderopen.gif', // node icon selected opened

	'icon_0'  : 'tigra/demo1/icons/page.gif', // leaf icon normal
	'icon_4'  : 'tigra/demo1/icons/page.gif', // leaf icon selected
	
	'icon_2'  : 'tigra/demo1/icons/joinbottom.gif', // junction for leaf
	'icon_3'  : 'tigra/demo1/icons/join.gif',       // junction for last leaf
	'icon_18' : 'tigra/demo1/icons/plusbottom.gif', // junction for closed node
	'icon_19' : 'tigra/demo1/icons/plus.gif',       // junctioin for last closed node
	'icon_26' : 'tigra/demo1/icons/minusbottom.gif',// junction for opened node
	'icon_27' : 'tigra/demo1/icons/minus.gif'       // junctioin for last opended node
};

function openMenu( ims_id ) {
    if (ims_id.n_depth > 0) {
	openMenu(ims_id.o_parent);
	if ( ! ims_id.b_opened )
          trees[ims_id.o_root.n_id].toggle(ims_id.n_id);
    } else {
	return;
    }
}

function selectItem( index ) {
      openMenu ( menu.a_index[index] );
      trees[menu.a_index[index].o_root.n_id].select(menu.a_index[index].n_id);
}

function seekAndDestroy( ims_id ) {
    // Traverse the tree until we reach level 1
    if ( ims_id.b_opened ) {
	seekAndDestroy(ims_id.o_parent);

	// Loop through this level and close all other opened items
	for(var i=0; i<ims_id.o_root.a_children.length; i++) {
	    if (ims_id.open == ims_id.o_root.a_children[i]) {
		// Same level, if opened and not in current
		// active menu, close
		if (ims_id.o_root.a_children[i].tmF && ims_id.o_root.a_children[i] != ims_id) {
		    alert('found opened');
		}
	    }
	}
    } else {
	return;
    }
}


function debug(message) {
        parent.frames['talk'].document.write("<FONT SIZE=1> menu.adp : "+message+"<HR>");
        return;
        }


function systemcheck() {
	debug("within syscheck");
	AppletContainerFrame=parent.frames['AppletContainerFrame'];
	//if (ie4) {
    		//while(isNull(document.getElementById("treemenu").style)) {
		//	alert("IL MENU e' NULL");
		//} else {
		//alert("IL MENU e' NON NULL");
			//will not hide in explorer 5.01
    			//document.getElementById("treemenu").style.display='none';
		//}
	//	debug("hidden treemenu");
	//} else {
	//	hide("treemenu");
	//}
	if (AppletContainerFrame.releasemenu==1) {
		//seems that ie 5.5 is not ie4 so forcing location wouldn't work
		<if @menu_off@ lt 1>
		//	if (ie4) {
			debug("menu released, going to call showmenu");
		//	showmenu(); 
		//	} else {
		//	show("treemenu");
		//	}
		</if>
		<else>
		parent.frames['content'].location.href = "record-view?man_id=@man_id@&item_id=@item_id@";
		</else>
	//do nothing
	} else {
	if (AppletContainerFrame.releasemenu==-1) {
	parent.frames['content'].document.write("<BR><HR>Failed system configuration test<BR>Please check requirements");
	parent.frames['content'].document.write("<HR>This window will now close.");
        setTimeout("closeme();",12000)
	} else {
	if((AppletContainerFrame.megatries<4)) {
	parent.frames['content'].document.write("<BR>Please wait. Checking system configuration<BR>");
	} else {
	parent.frames['content'].document.write("<BR><HR>Failed system configuration test<BR>Please check requirements");
	parent.frames['content'].document.write("<HR>This window will now close.");
        setTimeout("closeme();",12000)
	}
	}
	}
	return;
}


//-->
</script>

</head>


<BODY onload="return init();">

<div id="usermessage">
</div>

<div id="abort">
</div>

<div id="menudiv">
<if @menu_off@ lt 1>
    <a href="exit?man_id=@man_id@&track_id=@track_id@&return_url=@return_url@"  style="display: block; position: fixed;" class="button" target="_top">Exit Course</a>
&nbsp;
<hr size=1>
</if>


<hr>

<if @TREE_ITEMS@ defined>
<script language="JavaScript">
//<!--
	menu = new tree (this.TREE_ITEMS, this.tree_tpl);

	        <if @ims_id@ defined>
	        selectItem(this.TREE_HASH["ims_id.@ims_id@"]);
		</if>
//-->
</script>
</if>
<else>
Menu not available.
</else>
</div>


<HR>
<if @debuglevel@ gt 0>
debug is: ON 
</if>

</BODY>
</HTML>
