<%
#
#<master>
#
#
%>
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="/resources/dotlrn/dotlrn-master.css" media="all">
</head>
<body border=1>
<center>
    <script type="text/javascript">
      <!--
	//this doesn't make sense!
      // Check if we're inside and the tree menu is shown
      //if (window.parent.toc) {
	// Check if there is a menu to select from
	//if (window.parent.toc.menu) {
	//      window.parent.toc.selectItem(0);
	//}
      //}
      //-->
    </script>

<br>    
<h1><b>@course_name@</h1>
<p>

    <if @last_page_viewed@ defined>
      <p>
	#lorsm.lt_The_last_page_you_vie# <b><a href="record-view?man_id=@man_id@&item_id=@imsitem_id@">@last_page_viewed;noquote@</a></b>
    </if>
    <else>
       #lorsm.you_no_yet_viewed_any_material#
    </else>
    <p>
      #lorsm.lt_Click_on_menu_to_the_#
    </if>
<!--      
      <link rel="stylesheet" type="text/css" href="/resources/acs-templating/forms.css" media="all">
    
    

    <script src="/resources/acs-subsite/core.js" language="javascript"></script>

    <textarea id="holdtext" style="display: none;"></textarea>
    
-->


 </body>
</html>

