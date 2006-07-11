<html>
<head>
<title></title>

<script language="JavaScript">
//<!--

var API;
ns4 = (document.layers)? true:false;
ie4 = (document.all)? true:false;

function onunload() {
//alert("unloading me");
z=parent.closecontents();
if (this.parent.content.window.location.href != "blank.htm") {
 	setTimeout("onunload();",1000)
	}
}

function init() {
    API = this.document.APIAdapter;
    //document.applets[0].init();
    //alert("JAVA-JAVASCRIPT: i've inited myself");
}

function show(id) {
}

function hide(id) {
}

function changeSCOContent() {
    alert("LMSFINISH completing: getting out on JAVA APPLET request");
    this.parent.window.location.href = "@return_url@";
    return 1;
}

function showmenu() {
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
//-->
</script>

<script language="JavaScript" src="tigra/tree.js"></script>

<script language="JavaScript">
<!--
      var TREE_ITEMS = [['Course Index', 'body?man_id=@man_id@',

<if @TREE_ITEMS@ defined>@TREE_ITEMS;noquote@</if>

]];

      <if @TREE_HASH@ defined>
      var TREE_HASH = new Array();
      @TREE_HASH;noquote@
      </if>

//-->
</script>

<if @menu_off@ lt 1>
<style type="text/css">
      body { background-color: #6C9A83 }

      a { font-family: Helvetica,Arial; 
       font-weight: bold; 
       font-size: 0.7em;
       color: #FFFFFF;
      }
      
      a.current a:active { font-family: Helvetica,Arial; 
       font-weight: bold; 
       font-size: 0.7em;
       color: #FFFF00;
      }

      a.button { 
       font: 65% arial;
       border: solid 1px black;
       background-color: #e1e1e1;
       text-align: center; 
       padding: 1px;
       padding-left: 8px;
       padding-right: 8px;
       color: black;
       text-decoration: none;
       white-space: nowrap;
       position: fixed;
      }

      a.button:link { 
       text-decoration: none;
       border: solid 1px black;
      }

      a.button:visited { 
       text-decoration: none;
       border: solid 1px black;
      }

      a.button:hover { 
       text-decoration: none;
       background-color: #ccc;
       border: solid 1px black;
      }

      a.button:active { 
       text-decoration: none;
       border: solid 1px black;
      }

</style>
</if>

</head>


<body onload="init();"> 

<if @menu_off@ lt 1>
    <a href="exit?man_id=@man_id@&track_id=@track_id@&return_url=@return_url@"  style="display: block; position: fixed;" class="button" target="_top">Exit Course</a>
&nbsp;
<hr size=1>
</if>


<hr>

	<if @TREE_ITEMS@ defined>
	<script language="JavaScript">
	//<!--

		menu = new tree (TREE_ITEMS, tree_tpl);

	        <if @ims_id@ defined>
	        selectItem(TREE_HASH["ims_id.@ims_id@"]);
		</if>

	//-->
	</script>
	</if>
	<else>
		Menu not available.
	</else>



<HR>
<if @debuglevel@ gt 0>
debug is: ON 
</if>
<else>
</else>

</BODY>
</HTML>
