<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html401/loose.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<title></title>
<link rel="stylesheet" type="text/css" href="scorm.css" media="all">
<script type="text/javascript" src="tigra/tree.js"></script>
<script type="text/javascript">
//<!--
record_view_url="record-view?man_id=@man_id@&item_id=@ims_item_id@";
applet_url="applet?man_id=@man_id@&return_url=@return_url@<if @ims_item_id@ defined>&item_id=@ims_item_id@</if><if @ims_id@ defined>&ims_id=@ims_item_id@</if>&track_id=@track_id@<if @menu_off@ defined>&menu_off=@menu_off@</if>";
return_url="@return_url@";
menu_off=@menu_off@+0;
//copying tree from item to menu
var TREE_ITEMS = [['Course Index', 'body?man_id=@man_id@',
<if @TREE_ITEMS@ defined>@TREE_ITEMS;noquote@</if>
]];
<if @TREE_HASH@ defined>
var TREE_HASH = new Array();
@TREE_HASH;noquote@
</if>

//-->
</script>
<script type="text/javascript" src="menu.js"></script>
</head>

<if @rte@ true>
	<BODY onload="return menu_init();">
</if>
<else>
	<BODY>
</else>

<div id="usermessage" class="usermessage_class">
	<if @debuglevel@ gt 0>
	debug is: ON <br>
	delivery is: @deliverymethod@
	</if>
</div>

<div id="abort">
</div>

<div id="btn_finish">
</div>

<div id="menudiv">
<if @menu_off@ lt 1>
  <a href="exit?man_id=@man_id@&amp;track_id=@track_id@&amp;return_url=@return_url@" 
  class="button" target="_top">#lorsm.Exit_Course# <br> #lorsm.return_to_LRN#</a>
<div id="spacer">
<br><br><br>
</div>

<hr size=1>
</if>

<if @TREE_ITEMS@ defined>
<script type="text/javascript">
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


</BODY>
</HTML>
