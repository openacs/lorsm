# packages/lorsm/www/delivery-bottom-bar/bottom.tcl

ad_page_contract {
    
} {
	man_id:integer,notnull
	{item_id:integer ""}
} -properties {
} -validate {
} -errors {
}

# Student tracking
set package_id [ad_conn package_id]
set community_id [lors::get_community_id]
set user_id [ad_conn user_id]

if {[lorsm::track::istrackable -course_id $man_id -package_id $package_id]} {
    
    set track_id [lorsm::track::new \
		      -user_id $user_id \
		      -community_id $community_id \
		      -course_id $man_id]
} else {
    set track_id 0
}

# return_url
set return_url [lors::get_community_url]

set item_list [lorsm::get_item_list $man_id $user_id]

set last_item_viewed [db_string select_last_item_viewed {    
	select ims_item_id
	from views_views v,
	ims_cp_items i,
	ims_cp_organizations o
	where v.viewer_id = :user_id
	and v.object_id = i.ims_item_id
	and i.org_id = o.org_id
	and o.man_id = :man_id
	order by v.last_viewed desc
		limit 1
} -default "no_item"]

set first_item_id [lindex $item_list 0]
set first_item_url "<a href=\"[export_vars -base "record-view" -url {{item_id $first_item_id} man_id}]\" target=\"content\"><img src=\"Images/home.png\" border=\"0\" title=\"home\" onclick=\"window.location.reload()\"></a>"

set curr_index [expr [lsearch -exact $item_list $last_item_viewed]]
set prev_item_id [lindex $item_list [expr $curr_index - 1]]
set next_item_id [lindex $item_list [expr $curr_index + 1]]
set prev_url "<a href=\"[export_vars -base "record-view" -url {{item_id $prev_item_id} man_id}]\" target=\"content\"><img src=\"Images/prev.png\" border=\"0\" title=\"next\" onclick=\"window.location.reload()\"></a>"
set next_url "<a href=\"[export_vars -base "record-view" -url {{item_id $next_item_id} man_id}]\" target=\"content\"><img src=\"Images/next.png\" border=\"0\" title=\"next\" onclick=\"window.location.reload()\"></a>"

if { [string eq $last_item_viewed "no_item"] } {
	# first time accessing the course
	set next_url "<img src=\"Images/nexthide.png\" border=\"0\">"
	set prev_url "<img src=\"Images/prevhide.png\" border=\"0\">"
} elseif { ![expr [llength $item_list] - $curr_index - 1] }  {	
	# last item
	set next_url "<img src=\"Images/nexthide.png\" border=\"0\">"
} elseif { ![expr $curr_index] } {
	# first item
	set prev_url "<img src=\"Images/prevhide.png\" border=\"0\">"
}

