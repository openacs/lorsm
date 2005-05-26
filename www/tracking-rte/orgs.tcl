# packages/lorsm/www/delivery/toc.tcl

ad_page_contract {
    
    Course Delivery Table of Content
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-09
    @arch-tag 553390f0-450e-48db-99f0-c5dcb17978b8
    @cvs-id $Id$
} {
    man_id:integer,notnull  
    user_id:integer,notnull
} -properties {
} -validate {
} -errors {
}


# In order to share courses across classes, we need to share
# file-storage objects across file-storage instances. This has been
# proven to be really tricky. But here we pass the fs_package_id for
# the current community, so we don't have to have permissions for
# other instances of file-storages of other classes.  See
# documentation for further details.


db_multirow orgs select_orgs {
    select 
       org.org_id,
       org.org_title as org_title,
       org.hasmetadata,
       tree_level(o.tree_sortkey) as indent
    from
       ims_cp_organizations org, acs_objects o
    where
       org.org_id = o.object_id
     and
       man_id = :man_id
    order by
       org_id
}	{
	set org_title $org_title
} 


db_multirow suborgs select_suborgs {
        SELECT
		o.object_id,
 		repeat('&nbsp;', (tree_level(tree_sortkey) - :indent)* 2) as indent,
		i.item_id,
                i.item_title as item_title,
                i.hasmetadata,
		i.item_id as identifierref,
		i.type,
                i.org_id,
                m.fs_package_id,
	        m.folder_id,
	        m.course_name
        FROM 
		acs_objects o, ims_cp_items i, ims_cp_manifests m
	WHERE 
		o.object_type = 'ims_item'
           AND
		i.org_id = :org_id
	   AND
		o.object_id = i.item_id
           AND
                m.man_id = :man_id
        ORDER BY 
                object_id, tree_sortkey
} 



