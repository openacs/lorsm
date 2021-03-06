-- 
-- packages/lorsm/sql/postgresql/lorsm-create.sql
-- 
-- @author Ernie Ghiglione (ErnieG@mm.st)
-- @creation-date 2004-05-24
-- @arch-tag 168b43b5-5693-4d4a-a5e7-d629f8fb206b
-- @cvs-id $Id$
--

--
--  Copyright (C) 2004 Ernie Ghiglione
--
--  This package is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  It is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--




-- Creates tables to track student's progress

create table lorsm_student_track (
	track_id	int 
			constraint lorsm_st_track_id_pk
                        primary key,
	user_id		integer
                        constraint lorsm_st_track_user_id_fk
                        references users (user_id),
	community_id	integer
			constraint lorsm_st_track_comm_id_fk
			references groups (group_id),
	course_id	integer
			constraint lorsm_st_track_course_id_fk
			references ims_cp_manifests (man_id),
	start_time	timestamptz not null default current_timestamp,
	end_time	timestamptz
);

-- create track_id sequence
create sequence lorsm_st_track_track_id_seq start 1;

-- create index for lorsm_student_track_indexes
  -- student_id
  create index lorsm_st_track__user_id_idx on lorsm_student_track (user_id);
  -- community_id
  create index lorsm_st_track__comm_id_idx on lorsm_student_track (community_id);
  -- course_id
  create index lorsm_st_track__course_id_idx on lorsm_student_track (course_id);

comment on table lorsm_student_track is '
This table stores students tracking information. 
Multiplicity: each student can have many records of the same course/class. Remember, 
a course can be given in two different communities/classes 
';

create table lorsm_student_bookmark (
	user_id		integer
                        constraint lorsm_st_track_user_id_fk
                        references users (user_id),
	community_id	integer
			constraint lorsm_st_track_comm_id_fk
			references groups (group_id),
	course_id	integer
			constraint lorsm_st_track_course_id_fk
			references ims_cp_manifests (man_id),
	date		timestamptz,
			constraint lorsm_st_book_id_pk
			primary key (user_id, community_id, course_id)
);

-- create index for lorsm_student_book_indexes
  -- student_id
  create index lorsm_st_book__user_id_idx on lorsm_student_bookmark (user_id);
  -- community_id
  create index lorsm_st_book__comm_id_idx on lorsm_student_bookmark (community_id);
  -- course_id
  create index lorsm_st_book__course_id_idx on lorsm_student_bookmark (course_id);

comment on table lorsm_student_track is '
This table stores students bookmark information. We bookmarked the last page the page/link that the
student visited last.
Multiplicity: One bookmark per course/class/student
';

-- Course presentation formats

create table lorsm_course_presentation_formats (
	format_id  			integer
						constraint lorsm_cpformats_pk
						primary key,
	format_pretty_name	varchar(200),
	format_name 		varchar(100),
	folder_name			varchar(100)
);

create index lorsm_cpformats__format_id_idx on lorsm_course_presentation_formats (format_id);

comment on table lorsm_course_presentation_formats is '
This table stores the available presentation formats for the courses. Its contains the pretty name
for the format, an id, and the name of an adp in packages/lorsm/www/delivery where the presentation format is stored.';

create table lorsm_custom_pages (
	man_id integer
    	constraint lors_st_end_pgs_man_id_fk
        references ims_cp_manifests (man_id),
	page_id integer
	    constraint lors_st_end_pgs_start_id_fk
	    references cr_items (item_id),
	type varchar(100),
	constraint lcp_man_id_type_pk
        primary key (man_id, type)
);

comment on table lorsm_custom_pages is '
Allow a course creator to designate an ims_cp_item as the start page 
which appears before the couse is started, or tracking is enabled so the user 
can see what the course is about. End page is a concluding page that works the
same way';

\i lorsm-packages.sql
\i lorsm-cmi-create.sql
