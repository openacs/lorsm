<master>
<center>
    
<h1>Welcome to <b>@course_name@</h1>
<p>

      Your Stats:
      <br>
	You have seen this course <b>x</b> number of times and have covered <b>@viewed_percent@ %</b> of the content.
    </p>
    <if @last_page_viewed@ defined>
      <p>
	The last page you viewed was: <b><a href="record-view?man_id=@man_id@&item_id=@imsitem_id@">@last_page_viewed;noquote@</a></b>
    </if>
    <p>
      Click on menu to the left to view course materials.
      
      
      <link rel="stylesheet" type="text/css" href="/resources/acs-templating/forms.css" media="all">
    
      <link rel="stylesheet" type="text/css" href="/resources/acs-subsite/default-master.css" media="all">
    

    <script src="/resources/acs-subsite/core.js" language="javascript"></script>

    <textarea id="holdtext" style="display: none;"></textarea>

    
    <link rel="stylesheet" type="text/css" href="/resources/acs-subsite/site-master.css" media="all">

 </head>

 <body border=0>
<!-- <p align="center"><font size=+3">Welcome to LEON</font><br><font size=-1>Course Delivery System for LORS</font>
</p> -->

<!--
p align="center">&nbsp;&nbsp;Click on the Course Index items to start your <b>@course_name@</b> course.&nbsp;&nbsp;</p -->
  <p align="center">&nbsp;&nbsp;<b>@course_name@</b>.&nbsp;&nbsp;</p>
 </body>
</html>

