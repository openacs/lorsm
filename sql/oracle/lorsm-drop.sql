--
-- packages/lorsm/sql/postgresql/lorsm-drop.sql
--
-- @author Ernie Ghiglione (ErnieG@mm.st)
-- Adapted for Oracle by Mario Aguado <maguado@innova.uned.es>
-- @author Mario Aguado <maguado@innova.uned.es>
-- @creation-date 01/09/2006
-- @cvs-id $Id$
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

@@ lorsm-cmi-drop.sql

-- Drop tables and sequences

drop table lorsm_student_track;
drop table lorsm_student_bookmark;
drop table lorsm_course_presentation_fmts;

drop sequence lorsm_st_track_track_id_seq;

-- Unregister the content template
declare

 v_template_id cr_templates.template_id%TYPE;
begin
	v_template_id := content_type.get_template(
				content_type => 'file-storage-object',
				use_context  => 'lorsm'
	);

	content_type.unregister_template (
		content_type => 'file-storage-object',
		template_id => v_template_id,
		use_context => 'public'
	);

end;
/ 
show errors;

