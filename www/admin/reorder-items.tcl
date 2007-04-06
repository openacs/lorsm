ad_page_contract {
   Reorders all the items according to sort_order
} {
   item_id:integer,notnull
   dir:notnull
} 

set ims_item_id $item_id
set man_id [db_string get_man_id ""]
db_1row get_item_sort_and_parent { }

db_transaction {
    db_list lock_rows "select ims_item_id from ims_cp_items where parent_item=:parent_item for update"

    if { $dir eq "up" } {
	set next_sort_order [db_string get_prev_sort_order ""]
    } else {
	set next_sort_order [db_string get_next_sort_order ""]
    }

    db_dml swap_sort_orders "
update ims_cp_items
set sort_order = (case when sort_order = :sort_order :: integer then :next_sort_order :: integer when sort_order = :next_sort_order ::integer  then :sort_order end)
where parent_item=:parent_item
and sort_order in (:sort_order, :next_sort_order)
"

    } on_error {

    ad_return_error "Database error" "A database error occured while trying
to swap your items. Here's the error:
<pre>
$errmsg
</pre>
"
    ad_script_abort
}

ad_returnredirect "course-structure?man_id=$man_id"
