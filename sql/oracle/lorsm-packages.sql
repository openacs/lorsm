-- 
-- packages/lorsm/sql/oracle/lorsm-package.sql
-- 
-- @author Ernie Ghiglione (ErnieG@mm.st)
-- Adapted for Oracle by Mario Aguado <maguado@innova.uned.es>
-- @author Mario Aguado <maguado@innova.uned.es>
-- @creation-date 25/07/2006
-- @cvs-id $Id$
--

--
--  Copyright (C) 2006 Mario Aguado
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

create or replace package lorsm_lorsm_student_track as
	function new (
		p_user_id in lorsm_student_track.user_id%TYPE,
		p_community_id in lorsm_student_track.community_id%TYPE,
		p_course_id in lorsm_student_track.course_id%TYPE
	) return lorsm_student_track.track_id%TYPE;

	function exit (
		p_track_id in lorsm_student_track.track_id%TYPE
	) return lorsm_student_track.track_id%TYPE;
end lorsm_lorsm_student_track;
/
show errors;

create or replace package body lorsm_lorsm_student_track as

	function new (
		p_user_id in lorsm_student_track.user_id%TYPE,
		p_community_id in lorsm_student_track.community_id%TYPE,
		p_course_id in lorsm_student_track.course_id%TYPE
	) return lorsm_student_track.track_id%TYPE is
		v_track_id                lorsm_student_track.track_id%TYPE;
		v_start_time              date;
	begin

		select lorsm_st_track_track_id_seq.nextval into v_track_id
		from dual;
		v_start_time := sysdate;
		
		insert into lorsm_student_track (track_id, user_id, community_id, course_id, start_time)
		values
		(v_track_id, p_user_id, p_community_id, p_course_id, v_start_time);

		return v_track_id;

	end new;

	function exit (
		p_track_id in lorsm_student_track.track_id%TYPE
	) return lorsm_student_track.track_id%TYPE is
		v_end_time	date;
	begin
		v_end_time := sysdate;

		-- student leaves
		-- so we save the exit time
		update lorsm_student_track
		set end_time = v_end_time
		where track_id = p_track_id;

		return p_track_id;

	end exit;

end  lorsm_lorsm_student_track;
/
show errors;
