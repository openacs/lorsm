# packages/lorsm/www/shared/add-shared-course-2.tcl

ad_page_contract {
    
    Adds an existing course to a .LRN class
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-07-13
    @arch-tag: efa8621f-daa6-4743-9711-28a4195232ec
    @cvs-id $Id$
} {
    man_id:integer
    return_url
} -properties {
} -validate {
} -errors {
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set community_id [dotlrn_community::get_community_id]
set class_key [dotlrn_community::get_community_type_from_community_id $community_id]

# Permissions
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

# check admin permisssion for the community
set admin_p [dotlrn::user_can_admin_community_p  \
		 -user_id $user_id  \
		 -community_id $community_id ]

# check if the course is actually shared
if {[db_string isshared {select isshared from ims_cp_manifests where man_id = :man_id}] == "f"} {
    # if it ain't complain and quit
    ad_complain "The course you are trying to add to your class is not shared."

}

# check if the course is already added as course for this class

if {![db_0or1row exists {select man_id, lorsm_instance_id from ims_cp_manifest_class where man_id = :man_id \
			     and lorsm_instance_id = :package_id \
			     and community_id = :community_id}]} {
    ad_complain "The course [lorsm::get_course_name -manifest_id $man_id], is already part of your class"


}

db_dml add-course {insert into ims_cp_manifest_class \
		       (man_id, lorsm_instance_id, community_id, class_key, isenabled, istrackable) \
		       values \
		       (:man_id, :package_id, :community_id, :class_key, 't', 'f')}

ad_returnredirect $return_url