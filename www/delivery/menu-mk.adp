<html>
<head>
<title></title>
<script language="javascript" src="/resources/acs-templating/mktree.js"></script>
<link rel="stylesheet" href="/resources/acs-templating/mktree.css" type="text/css"> 

<style type="text/css">
      body { background-color: #6C9A83; margin:0px; }

      a { font-family: Helvetica,Arial; 
       font-weight: bold; 
       font-size: 0.7em;
       color: #FFFFFF;
      }
      
      a.current a:active { font-family: Helvetica,Arial; 
       font-weight: bold; 
       font-size: 0.7em;
       color: #FFFF00;
      }

      a.button { 
       font: 65% arial;
       border: solid 1px black;
       background-color: #e1e1e1;
       text-align: center; 
       padding: 1px;
       padding-left: 8px;
       padding-right: 8px;
       color: black;
       text-decoration: none;
       white-space: nowrap;
       position: fixed;
      }

      a.button:link { 
       text-decoration: none;
       border: solid 1px black;
      }

      a.button:visited { 
       text-decoration: none;
       border: solid 1px black;
      }

      a.button:hover { 
       text-decoration: none;
       background-color: #ccc;
       border: solid 1px black;
      }

      a.button:active { 
       text-decoration: none;
       border: solid 1px black;
      }

    ul.mktree  li.liOpen    .bullet { cursor: pointer; background: url(/resources/acs-templating/minus.gif)  center left no-repeat; }
    ul.mktree  li.liClosed  .bullet { cursor: pointer; background: url(/resources/acs-templating/plus.gif)   center left no-repeat; }
    ul.mktree  li.liBullet  .bullet { cursor: default; background: url(/resources/acs-templating/bullet.gif) center left no-repeat; }

</style>
</head>
<body>
    <a href="exit?man_id=@man_id@&track_id=@track_id@&return_url=@return_url@"  style="display: block; position: fixed;" class="button" target="_top">#lorsm.Exit_Course# <br> #lorsm.return_to_LRN#</a>
&nbsp;

<hr size="1" />
<ul class="mktree" id="tree1">
<multiple name="tree_items">
<if @tree_items.indent@ gt @tree_items.last_indent@><ul></if>
<if @tree_items.indent@ lt @tree_items.last_indent@></li></ul></if>
<if @tree_items.indent@ eq @tree_items.last_indent@ and @tree_items.rownum@ ne 1></li></if>
<li><a href="@tree_items.link@" <if @tree_items.target@ not nil>target="@tree_items.target@"</if>>@tree_items.label@ </a>
<if @tree_items.rownum@ eq @tree_items:rowcount@></li></if>
</multiple>
</ul>
</li>
</ul>

</body>
</html>