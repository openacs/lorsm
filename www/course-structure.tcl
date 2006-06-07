# # packages/lorsm/www/course_structure.tcl

 ad_page_contract {
   
     View Manifest Course Structure
    
     @author Ernie Ghiglione (ErnieG@mm.st)
     @creation-date 2004-03-31
     @arch-tag 208f2801-d110-45d3-9401-d5eae1f72c93
     @cvs-id  $Id$
 } {
     man_id:integer,notnull	
 } -properties {
 } -validate {
 } -errors {
 }

# set package_id [ad_conn package_id]
# set community_id [dotlrn_community::get_community_id]

# ad_proc -public getFolderKey {
#     {-object_id:required}
# } {
#     Gets the Folderkey for a file-storage folder_id

#     @option object_id Folder_id for file-storage folder
#     @author Ernie Ghiglione (ErnieG@mm.st)

# } {
#     return [db_string select_folder_key "select key from fs_folders where object_id = :object_id"]
# }

# set context & title
 set context [list "[_ lorsm.Course_Structure]"]
 set title "[_ lorsm.Course_Structure]"
