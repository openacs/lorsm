set user_id [ad_conn user_id]

if { $user_id != 0 } {
    set user_name [person::name -person_id $user_id]
}

