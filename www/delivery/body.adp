<master>
<center>
    <script type="text/javascript">
      <!--
      // Check if we're inside and the tree menu is shown
      if (window.parent.toc) {
      window.parent.toc.selectItem(0);
      }
      //-->
    </script>
    
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
