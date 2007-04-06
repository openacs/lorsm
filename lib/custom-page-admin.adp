
<table class="list" cellpadding="3" cellspacing="1" width="70%">
<multiple name="custom_pages">
<tr class="list-even">
<td width="20%" style="background-color: #e0e0e0; font-weight: bold;">
@custom_pages.pretty_name@
</td>
<td>
<if @custom_pages.ims_item_id@ not nil>
    @custom_pages.item_title@ <a href="item-add-edit?man_id=@man_id@&item_id=@custom_pages.item_id@">Edit</a>
</if><else>None</else>
 | <a href="set-custom-page?man_id=@man_id@&type=@custom_pages.type@">
<if @custom_pages.ims_item_id@ not nil>Change</if>
<else>Choose</else>
  @custom_pages.type@ page</a> | 
<if @custom_pages.ims_item_id@ not nil>
  <a href="remove-custom-page?man_id=@man_id@&type=@custom_pages.type@">Remove</a>
</if>
</td>
</tr>
</multiple>
</table>