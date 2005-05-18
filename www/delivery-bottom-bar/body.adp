<master  src="/www/blank-master">
<center>
    
<h1>#lorsm.Welcome_to# <b>@course_name@</h1>
<p>

      #lorsm.Your_Stats#
      <br>
	#lorsm.lt_You_have_seen_this_co# <b>@viewed_times@</b> #lorsm.lt_number_of_times_and_h# <b>@viewed_percent@ %</b> #lorsm.of_the_content#
    </p>
    <if @last_page_viewed@ defined>
      <p>
	#lorsm.lt_The_last_page_you_vie# <b><a href="record-view?man_id=@man_id@&item_id=@imsitem_id@">@last_page_viewed;noquote@</a></b>
    </if>
 	<else>
	<a href="record-view?man_id=@man_id@&item_id=@first_item_id@" onclick="parent.frames['bottom'].location.reload()">#lorsm.Start#</a>
	</else>

