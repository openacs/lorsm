-- 
-- 
-- 
-- @author Dave Bauer (dave@thedesignexperience.org)
-- @creation-date 2008-04-13
-- @cvs-id $Id$
--


create table lorsm_custom_pages (
	man_id integer
	constraint lors_st_end_pgs_man_id_pk
        primary key 
	constraint lors_st_end_pgs_man_id_fk
        references ims_cp_manifests (man_id),
	page_id integer
	constraint lors_st_end_pgs_start_id_fk
	references cr_items (item_id),
	type varchar(100)
);

comment on table lorsm_custom_pages is '
Allow a course creator to designate an ims_cp_item as the start page 
which appears before the couse is started, or tracking is enabled so the user 
can see what the course is about. End page is a concluding page that works the
same way';
