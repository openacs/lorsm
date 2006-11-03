<%
#
#<master>
#
#
%>
<html>
<head>
<title>@course_name@</title>
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
	Last page viewed: <b><a href="record-view?man_id=@man_id@&item_id=@imsitem_id@">@last_page_viewed;noquote@</a></b>
    </if>
    <else>
        You have not yet viewed any material from this course.
    </else>
    <p>
      Click on the menu items on the left to view course materials
    </if>
<!--      
      <link rel="stylesheet" type="text/css" href="/resources/acs-templating/forms.css" media="all">
    
    

    <script src="/resources/acs-subsite/core.js" language="javascript"></script>

    <textarea id="holdtext" style="display: none;"></textarea>
    
-->


 </body>
</html>

