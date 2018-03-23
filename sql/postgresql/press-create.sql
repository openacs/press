-- /packages/press/sql/press-create.sql
--
-- @author sarah@arsdigita.com
-- @author stefan@arsdigita.com
-- @author ron@arsdigita.com
-- @author michael@steigman.net
--
-- @created 2000-11-15
--
-- $Id$

--
-- Permissions
--


-- the read privilege is by default granted to 'the_public'
-- the site-wide administrator has to change this in /permissions/ 
-- if he wants to restrict an instance to a specific party_id only

-- the press_admin has all privileges, read, create, delete, approve
-- it is a child of 'admin'

select acs_privilege__create_privilege('press_read',null,null);
select acs_privilege__create_privilege('press_create',null,null);
select acs_privilege__create_privilege('press_delete',null,null);
select acs_privilege__create_privilege('press_approve',null,null);

    -- bind privileges to global names  
select acs_privilege__add_child('read','press_read');
select acs_privilege__add_child('create','press_create');
select acs_privilege__add_child('delete','press_delete');
select acs_privilege__add_child('admin','press_approve');

-- add this to the press_admin privilege
select acs_privilege__create_privilege('press_admin','Press administrator',null);

-- press administrator binds to global 'admin', plus inherits press_* permissions
select acs_privilege__add_child('admin','press_admin');       
select acs_privilege__add_child('press_admin','press_approve');
select acs_privilege__add_child('press_admin','press_create');
select acs_privilege__add_child('press_admin','press_delete');

-- assign permission to defined contexts within ACS by default
--

create function inline_0 ()
returns integer as '
declare
    default_context  acs_objects.object_id%TYPE;
    registered_users acs_objects.object_id%TYPE;
    the_public       acs_objects.object_id%TYPE;
begin
    default_context  := acs__magic_object_id(''default_context'');
    registered_users := acs__magic_object_id(''registered_users'');
    the_public       := acs__magic_object_id(''the_public'');

    -- give the public permission to read by default
    perform acs_permission__grant_permission (
        default_context,        -- object_id
        the_public,             -- grantee_id
        ''press_read''          -- privilege
    );

    -- outcomment if your site wants to 
    -- give registered users permission to upload items by default
    -- perform acs_permission__grant_permission (
    --    default_context,      -- object_id
    --    registered_users,     -- grantee_id
    --    ''press_create''      -- privilege
    -- );

    return 0;
end;
' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();

-- this table stores the different adp-templates to show a press item

create table press_templates (
    template_id        integer primary key not null,
    -- we use this to select the template
    template_name      varchar(100) not null unique,
    -- the adp code fragment
    template_adp       text not null
);

-- We use the content repository to store most of the information for
-- press items.
--
-- See http://cvs.arsdigita.com/acs/packages/acs-content-repository)

create  table cr_press (
    press_id                    integer
                                constraint cr_press_id_fk references cr_revisions
                                constraint cr_press_pk primary key,
    -- include package_id to provide support for multiple instances
    package_id                  integer,
    -- constraint cr_press_package_id_nn not null,                      
    -- information about the publication where this press item appeared
    -- *** The journal name, the journal URL ***
    publication_name            varchar(100)
                                constraint cr_press_publication_name_nn not null,
    publication_link            varchar(200),
    -- *** the specific journal issue ***
    publication_date            timestamptz not null,
    publication_date_desc       varchar(100),
    -- *** the article link, pages ***
    article_link                varchar(400),
    article_pages               varchar(40),
    article_abstract_html_p     varchar(1) 
                                constraint cp_article_abstract_html_p_ck
                                check (article_abstract_html_p in ('t','f')),
    -- *** support for dates when items are displayed or archived ***
    -- unapproved release dates are null
    release_date                timestamptz,
    -- unscheduled archiving dates are null
    archive_date                timestamptz,
    -- support for approval, if ApprovalRequiredP == 1
    approval_user               integer
                                constraint cr_press_approval_user_fk
                                references users,
    approval_date               timestamptz,
    approval_ip                 varchar(50),
    -- *** presentation information ***
    -- supply own press-specific templates (see table below) until
    -- template system is better organized and documented
    template_id                 integer default 1 
                                constraint cr_press_templ_id references press_templates 
);


-- index to avoid lock situation through parent table
-- cr_press_press_id_fk is not created because press_id 
-- is already indexed through virtue of being the primary 
-- key for the table

create index cr_press_appuser_fk on cr_press(approval_user);

-- Initialize with one site-wide Default template
-- Make sure that you pass the following variables to the template
-- @publication_link@ (optional)
-- @publication_name@
-- @article_link@     (optional)
-- @article_title@
-- @pretty_publication_date@
-- @html_p@
-- @article_abstract@

insert into press_templates
    (template_id,       
     template_name,
     template_adp)
values
    (1,
     'Default',
     '<b>@publication_name@</b> - @article_title@<br> @publication_date@ : "@article_abstract@"');          

select content_type__create_type (
    'press',            -- content_type
    'content_revision', -- supertype
    'Press Item',       -- pretty_name
    'Press Items',      -- pretty_plural
    'cr_press',         -- table_name
    'press_id',         -- id_column
    'news__name'        -- name_method
);

-- create attributes for widget generation later

-- publication in which the press article appeared

select content_type__create_attribute (
    'press',            -- content_type
    'publication_name', -- attribute_name
    'text',             -- datatype
    'Publication',      -- pretty_name
    'Publications',     -- pretty_plural
    null,               -- sort_order
    null,               -- default_value
    'varchar(100)'      -- column_spec
);

-- URL link to this publication

select content_type__create_attribute (
    'press',            -- content_type
    'publication_link', -- attribute_name
    'text',             -- datatype
    'Publication URL',  -- pretty_name
    'Publication URL',  -- pretty_plural
    null,               -- sort_order
    null,               -- default_value
    'varchar(200)'      -- column_spec
);

-- issue date

select content_type__create_attribute (
    'press',            -- content_type
    'publication_date', -- attribute_name
    'date',             -- datatype
    'Publication Date', -- pretty_name
    'Publication Dates',-- pretty_plural
    null,               -- sort_order
    null,               -- default_value
    'timestamptz'       -- column_spec
);

-- issue date in words (optional)

select content_type__create_attribute (
    'press',                    -- content_type
    'publication_date_desc',    -- attribute_name
    'text',                     -- datatype
    'Publication Date Description', -- pretty_name
    'Publication Date Description', -- pretty_plural
    null,                       -- sort_order
    null,                       -- default_value
    'varchar(100)'              -- column_spec
);

-- URL link to the article 

select content_type__create_attribute (
    'press',            -- content_type
    'article_link',     -- attribute_name
    'text',             -- datatype
    'Article Link',     -- pretty_name
    'Article Links',    -- pretty_plural
    null,               -- sort_order
    null,               -- default_value
    'varchar(400)'      -- column_spec
);

-- article page range, e.g. 'pp 83-100'

select content_type__create_attribute (
    'press',            -- content_type
    'article_pages',    -- attribute_name
    'text',             -- datatype
    'Article Pages',    -- pretty_name
    'Articles Pages',   -- pretty_plural
    null,               -- sort_order
    null,               -- default_value
    'varchar(40)'       -- column_spec
);

-- a flag that tells if the article abstract is in HTML or not

select content_type__create_attribute (
    'press',            -- content_type
    'article_abstract_html_p', -- attribute_name
    'text',             -- datatype
    'Article Abstract HTML Flag', -- pretty_name
    'Article Abstract HTML Flag', -- pretty_plural
    null,               -- sort_order
    null,               -- default_value
    'varchar(1)'        -- column_spec
);

-- release date of press release

select content_type__create_attribute (
    'press',            -- content_type
    'release_date',     -- attribute_name
    'timestamp',        -- datatype
    'Release Date',     -- pretty_name
    'Release Dates',    -- pretty_plural
    null,               -- sort_order
    current_date::varchar,  -- default_value
    'timestamptz'       -- column_spec
);

-- archive date of press release

select content_type__create_attribute (
    'press',            -- content_type
    'archive_date',     -- attribute_name
    'timestamp',        -- datatype
    'Archival Date',    -- pretty_name
    'Archival Dates',   -- pretty_plural
    null,               -- sort_order
    null,               -- default_value
    'timestamptz'       -- column_spec
);

-- assignment to an authorized user for approval

select content_type__create_attribute (
    'press',            -- content_type
    'approval_user',    -- attribute_name
    'integer',          -- datatype
    'Approval User',    -- pretty_name
    'Approval Users',   -- pretty_plural
    null,               -- sort_order
    null,               -- default_value
    'integer'           -- column_spec
);

-- approval date

select content_type__create_attribute (
    'press',            -- content_type
    'approval_date',    -- attribute_name
    'timestamp',        -- datatype
    'Approval Date',    -- pretty_name
    'Approval Dates',   -- pretty_plural
    null,               -- sort_order
    current_date::varchar,  -- default_value
    'timestamptz'       -- column_spec
);

-- approval IP address

select content_type__create_attribute (
    'press',            -- content_type
    'approval_ip',      -- attribute_name
    'text',             -- datatype
    'Approval IP',      -- pretty_name
    'Approval IPs',     -- pretty_plural
    null,               -- sort_order
    null,               -- default_value
    'varchar'           -- column_spec
);

-- CREATE THE PRESS FOLDER as our CONTAINER ***

-- create 1 press folder; different instances are filtered by package_id
-- associate content types with press folder 

create function inline_0 ()
returns integer as '
declare
    v_folder_id cr_folders.folder_id%TYPE;
begin
    v_folder_id := content_folder__new (
        ''press'',      -- name
        ''press'',      -- label
        ''Press Item Root Folder, all press items go in here'', -- description
	null            -- parent_id
    );
    perform content_folder__register_content_type (
        v_folder_id,    -- folder_id
        ''press'',      -- content_type
        ''t''           -- include_subtypes
    );
    perform content_folder__register_content_type (
        v_folder_id,            -- folder_id
        ''content_revision'',   -- content_type
        ''t''                   -- include_subtypes
    );

    return 0;
end;
' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();

-- press plsql

\i press-package-create.sql

--
-- views on cr_press that combine information from cr_press, cr_items, cr_revisions 
--

-- view of all press items in the system 

create or replace view press_items
as 
select ci.item_id as item_id,
       press_id,
       cp.package_id,
       publication_name,
       publication_link,
       publication_date,
       publication_date_desc,
       cr.title as article_title,
       cr.content as article_abstract,
       cr.description as revision_note,
       article_link,
       article_pages,
       article_abstract_html_p,
       release_date,
       archive_date,
       live_revision,
       press__status(press_id) as status
  from cr_items ci, cr_revisions cr, cr_press cp
 where (    ci.item_id       = cr.item_id
   and ci.live_revision = cr.revision_id 
   and cr.revision_id   = cp.press_id)
    or (    ci.live_revision is null 
   and ci.item_id       = cr.item_id
   and cr.revision_id   = content_item__get_latest_revision(ci.item_id)
   and cr.revision_id   = cp.press_id);

--  view on all approved press items (active revision only)

create or replace view press_items_approved
as
select ci.item_id as item_id,
       cp.package_id,
       publication_name,
       publication_link,
       publication_date,
       publication_date_desc,
       cr.title as article_title,
       cr.content as article_abstract,
       cr.description as revision_note,
       article_link,
       article_pages,
       article_abstract_html_p as html_p,
       release_date,
       archive_date,
       pt.template_id,
       pt.template_name,
       pt.template_adp
  from cr_items ci, cr_revisions cr, cr_press cp, press_templates pt       
 where ci.item_id       = cr.item_id
   and ci.live_revision = cr.revision_id
   and cr.revision_id   = cp.press_id
   and pt.template_id   = cp.template_id;

-- view of all revisions of a press item

create or replace view press_item_revisions
as 
select revision_id,
       cr.item_id as item_id,
       cp.package_id,
       cp.publication_name,
       cp.publication_link,
       cp.publication_date,
       cp.publication_date_desc,
       cr.title as article_title,
       cr.content as article_abstract,
       cr.description as revision_note,
       cp.article_link,
       article_pages,
       article_abstract_html_p as html_p,
       release_date,
       archive_date,
       cp.template_id,
       template_name,
       template_adp,
       creation_date,
       press__status(press_id) as status,
       first_names || ' ' || last_name as item_creator,
       creation_ip,
       ci.name as item_name
  from cr_revisions cr, cr_press cp, press_templates pt, cr_items ci, acs_objects ao, persons
 where cr.revision_id   = ao.object_id
   and cr.revision_id   = cp.press_id
   and cp.template_id   = pt.template_id
   and ci.item_id       = cr.item_id
   and ao.creation_user = persons.person_id;
