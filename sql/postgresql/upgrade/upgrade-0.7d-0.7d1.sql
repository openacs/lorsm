-- 
-- packages/lorsm/sql/postgresql/upgrade-0.7d-0.7d1.sql
-- 
-- Upgrade datamodel for Oracle compatibility.
-- @author Mario Aguado <maguado@innova.uned.es>
-- @creation-date 01/09/2006
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

alter table lorsm_course_presentation_formats rename to lorsm_course_presentation_fmts;

--Column
alter table lorsm_student_bookmark rename column date to bookmark_date;

--Index
alter table lorsm_cpformats__format_id_idx rename to  lorsm_cpfmts__format_id_idx;

--Column
alter table lorsm_cmi_objectives rename column _count to objectives_count;

--Index
alter table lorsm_cmi_objectives__stud_id_idx rename to lorsm_cmi_obj_stud_id_idx;
alter table lorsm_cmi_student_data__stud_id_idx rename to lorsm_cmi_st_data_stud_id_idx;
alter table lorsm_cmi_student_preference__stud_id_idx rename to lorsm_cmi_st_pref_stud_id_idx;

alter table lorsm_cmi_interactions_objectives rename to lorsm_cmi_interact_objectives;

--Column
alter table lorsm_cmi_interactions rename column _count to interactions_count;
alter table lorsm_cmi_interact_objectives rename column _count to interactions_objectives_count;


--Index 
alter table  lorsm_cmi_interactions_obj__stud_id_idx rename to lorsm_cmi_int_obj_stud_id_idx;

alter table lorsm_cmi_interactions_correct_responses rename to lorsm_cmi_int_correct_respons;
--Column
alter table lorsm_cmi_int_correct_respons rename column _count to correct_responses_count;
