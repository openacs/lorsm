


  <if @imsitem_id@ ne "">
    <script type="text/javascript">
      <!--
      // Check if we're inside and the tree menu is shown
      if (window.parent.toc) {
      window.parent.toc.selectItem(window.parent.toc.TREE_HASH["ims_id.@imsitem_id@"]);
      }
      //-->
    </script>
  </if>

  <if @write_p@>

    <a href="@community_url@/file-storage/file-content-edit?file_id=@content.item_id@<if @return_url@ defined>&@return_url;noquote@</if>" target="_top"><img src="/resources/Edit16.gif" border="0" align="right" alt="image"></a>

  </if>

  <if @man_id@ defined>
    <a href="@community_url@/lorsm/admin/tracking?man_id=@man_id@<if @return_url@ defined>&@return_url;noquote@</if>" target="_top"><img src="/resources/ZoomIn16.gif" border="0" align="right" alt="image"></a>
  </if>


  <h3><img src="/resources/Open16.gif">@title;noquote@</h3>
  
  <blockquote>

    <if @text@ defined>
      @text;noquote@
    </if>

    <ul>
      <multiple name="children">
	<li><a href="@children.href@">@children.child_title@</a>
      </multiple>
    </ul>

    <br>
      
  </blockquote>
  <if @parent_item@>
    <a href="@parent_href@"><img border="0" src="/resources/right.gif" align="right" alt="Back to Parent"></a>
  </if>
