-- 
-- packages/lorsm/sql/postgresql/lorsm-package.sql
-- 
-- @author Ernie Ghiglione (ErnieG@mm.st)
-- @creation-date 2004-05-24
-- @arch-tag b0b73549-814c-4718-9537-f856b972d10f
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

-- student track package

create or replace function lorsm_student_track__new (integer,integer,integer)
returns integer as '
declare
  p_user_id                 alias for $1;
  p_community_id            alias for $2;
  p_course_id               alias for $3;
  v_track_id                lorsm_student_track.track_id%TYPE;
  v_start_time              timestamptz;
begin
    select nextval(''lorsm_st_track_track_id_seq'')
    into v_track_id
    from dual;

   v_start_time := now();

    -- inserts into 
	insert into lorsm_student_track
	  (track_id, user_id, community_id, course_id, start_time)
	values
	  (v_track_id, p_user_id, p_community_id, p_course_id, v_start_time);

	return v_track_id;

end;' language 'plpgsql';


create or replace function lorsm_student_track__exit (integer)
returns integer as '
declare
  p_track_id                alias for $1;
  v_end_time                timestamptz;
begin

   v_end_time := now();

   -- student leaves
   -- so we save the exit time
	update lorsm_student_track
	   set end_time = v_end_time
        where track_id = p_track_id;

	return p_track_id;

end;' language 'plpgsql';
