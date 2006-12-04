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
<if @include_content@ not nil>
@include_content;noquote@
</if>
<if @show_next@ and @last_item_p@ false>
<p>
<span class="next-button">
<a href="@next_url;noquote@">Next</a>
</span>
</p>
</if>
<if @last_item_p@ true>
<a href="@next_url;noquote@">EXIT COURSE</a>
</if>
</body>
</html>