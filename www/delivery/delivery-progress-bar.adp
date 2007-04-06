<html>
<head>
<title>@page_title@</title>
<style>
.current-item { font-weight: bold; font-size: 1.2em; }
.next-button { margin: 4px; padding-left: 4px; padding-right: 4px; border-top: 2px solid #fff; border-left: 2px solid #fff; border-right: 2px solid #999; border-bottom: 2px solid #999; background-color: #eee;}
.next-button a { text-decoration: none; color: black; font-size: .8em; font-family: sans-serif;}
</style>
@header_stuff;noquote@
</head>
<body>
<h1>@current_title@</h1>
<include src="/packages/acs-tcl/lib/static-progress-bar" total="@progress_total_pages@" current="@progress_current_page@" finish="@last_item_p@">

<if @include_content@ not nil>
@include_content;noquote@
</if>
<if @show_next@ and @last_item_p@ false>
<p>
<span class="next-button">
<a href="@next_url;noquote@">@next_link_text@</a>
</span>
</p>
</if>
<if @last_item_p@ true>
<a href="@next_url;noquote@">EXIT COURSE</a>
</if>
</body>
</html>