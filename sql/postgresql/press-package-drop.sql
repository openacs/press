-- /packages/press/sql/press-package-drop.sql
--
-- @author michael@steigman.net
--
-- @created 2003-10-23
--
-- $Id$

drop function press__new (varchar,varchar,varchar,timestamptz,varchar,varchar,varchar,varchar,integer,timestamptz,varchar,timestamptz,timestamptz,integer,integer,integer,varchar,varchar,varchar,varchar,varchar,varchar,integer,varchar,varchar,varchar,varchar,timestamptz,varchar,integer);
drop function press__delete (integer);
drop function press__make_permanent (integer);
drop function press__archive (integer,timestamptz);
drop function press__approve (integer,varchar);
drop function press__approve_release (integer,timestamptz,timestamptz);
drop function press__set_active_revision (integer);
drop function press__is_live (integer);
drop function press__status (integer);
drop function press_revision__new (varchar,varchar,varchar,varchar,integer,integer,varchar,integer,varchar,varchar,timestamptz,varchar,varchar,varchar,varchar,integer,timestamptz,varchar,timestamptz,timestamptz,integer,varchar,varchar);
drop function press_revision__delete (integer);
