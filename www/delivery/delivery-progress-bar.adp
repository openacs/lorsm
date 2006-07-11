<html>
<head>
<title>@current_title@</title>
<style>
.current-item { font-weight: bold; font-size: 1.2em; }
.next-button { margin: 4px; padding-left: 4px; padding-right: 4px; border-top: 2px solid #fff; border-left: 2px solid #fff; border-right: 2px solid #999; border-bottom: 2px solid #999; background-color: #eee;}
.next-button a { text-decoration: none; color: black; font-size: .8em; font-family: sans-serif;}
</style>
</head>
<body>
<h1>@current_title@</h1>
<p><list name="progress_list"><if @progress_list:item@ eq @progress_index@><span class="current-item">[@progress_list:item@]</span></if><else>[@progress_list:item@]</else></list>
</p>
<if @__include@ not nil>
<include src="@__include@">
</if>
<if @show_next@>
<if @next_item_id@ ne "">
<p>
<span class="next-button">
<a href="@next_url;noquote@">Next</a>
</span>
</p>
</if>
<else>
<a href="@next_url;noquote@">EXIT COURSE</a>
</else>
</if>
</body>
</html>