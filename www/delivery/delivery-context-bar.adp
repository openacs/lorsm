<html>
<head>
<title>@current_title@</title>
<style>
.current-item { font-weight: bold; font-size: 1.2em; }
</style>
</head>
<body>
<h1>@current_title@</h1>
<h2>item_id @item_id@</h2>
<p><list name="progress_list"><if @progress_list:item@ eq @progress_index@><span class="current-item">[@progress_list:item@]</span></if><else>[@progress_list:item@]</else></list>
</p>
<if @__include@ not nil>
<include src="@__include@">
</if>
<if @show_next@><a href="@next_url@">NEXT</a></if>
</body>
</html>