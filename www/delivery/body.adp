<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html401/loose.dtd">

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<title></title>
<link rel="stylesheet" type="text/css" href="/resources/dotlrn/dotlrn-master.css" media="all">
</head>
<body>
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
<h1><b>@course_name@</b></h1>
<p>

    <if @last_page_viewed@ defined>
      <p>
	Last page viewed: <b><a href="record-view?man_id=@man_id@&amp;item_id=@imsitem_id@">@last_page_viewed;noquote@</a></b>
    </if>
    <else>
        You have not yet viewed any material from this course.
    </else>
    <p>
      Click on the menu items on the left to view course materials
<!--      
      <link rel="stylesheet" type="text/css" href="/resources/acs-templating/forms.css" media="all">
    
    

    <script src="/resources/acs-subsite/core.js" type="text/javascript"></script>

    <textarea id="holdtext" style="display: none;"></textarea>
    
-->

   </center>
 </body>
</html>

