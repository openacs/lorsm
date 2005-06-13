--
-- packages/lorsm/sql/postgresql/lorsm-drop.sql
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

-- Drop tables and sequences

drop table lorsm_student_track;
drop table lorsm_student_bookmark;

drop sequence lorsm_st_track_track_id_seq;

-- Unregister the content template
select content_type__unregister_template (
       'file-storage-object',
       content_type__get_template('file-storage-object','lorsm'),
       'public'
);

