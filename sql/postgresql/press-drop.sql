-- /packages/press/sql/press-drop.sql
--
-- @author sarah@arsdigita.com
-- @author stefan@arsdigita.com
-- @author ron@arsdigita.com
-- @author michael@steigman.net
--
-- @created 2000-11-27
--
-- $Id$

-- delete press views

drop view press_items_approved;
drop view press_item_revisions;
drop view press_items;

-- drop plpgsql

\i press-package-drop.sql

-- unregister content_types from folder

create function inline_0 ()
returns integer as '
declare
    v_folder_id         cr_folders.folder_id%TYPE;
    v_item_cursor       record;
begin
    v_folder_id := content_item__get_id(''press'',null,''f'');

    -- delete all contents of press folder
    for v_item_cursor in 
        select item_id 
          from cr_items 
         where parent_id = v_folder_id
    loop
        perform content_item__delete(press_rec.item_id);
    end loop;

    -- cheesy sub for cursor that doesnt work. need to fix.
    -- update cr_items set parent_id=0 where parent_id = v_folder_id;
    -- unregister_content_types

    perform content_folder__unregister_content_type (
        v_folder_id,            -- folder_id
        ''content_revision'',   -- content_type
        ''t''                   -- include_subtypes
    );

    perform content_folder__unregister_content_type (
        v_folder_id,            -- folder_id
        ''press'',              -- content_type
        ''t''                   -- include_subtypes
    );

    -- delete press folder

    perform content_folder__delete(v_folder_id);

    return 0;
end;
' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();

-- drop attributes

-- the Journal in which the press article appeared
select content_type__drop_attribute (
    'press',            -- content_type
    'publication_name', -- attribute_name
    'f'                 -- drop_column
);
-- the URL link to this Journal 
select content_type__drop_attribute (
    'press',            -- content_type
    'publication_link', -- attribute_name
    'f'                 -- drop_column
);
-- the journal issue date
select content_type__drop_attribute (
    'press',            -- content_type
    'publication_date', -- attribute_name
    'f'                 -- drop_column
);
-- the journal issue date in words
select content_type__drop_attribute (
    'press',            -- content_type
    'publication_date_desc', -- attribute_name
    'f'                 -- drop_column
);
-- the URL link to the article 
select content_type__drop_attribute (
    'press',            -- content_type
    'article_link',     --  attribute_name
    'f'                 -- drop_column
);
-- the article page range, e.g. 'pp 83-100'
select content_type__drop_attribute (
    'press',            -- content_type
    'article_pages',    -- attribute_name
    'f'                 -- drop_column
);
-- a flag that tells if the article abstract is in HTML or not
select content_type__drop_attribute (
    'press',                    -- content_type
    'article_abstract_html_p',  -- attribute_name
    'f'                         -- drop_column
);
-- website release date of press release
select content_type__drop_attribute (
    'press',            -- content_type
    'release_date',     -- attribute_name
    'f'                 -- drop_column
);
-- website archive date of press release
select content_type__drop_attribute (
    'press',            -- content_type
     'archive_date',    -- attribute_name
    'f'                 -- drop_column
);
-- assignement to an authorized user for approval
select content_type__drop_attribute (
    'press',            -- content_type
    'approval_user',    -- attribute_name
    'f'                 -- drop_column
);
-- approval date
select content_type__drop_attribute (
    'press',            -- content_type
    'approval_date',    -- attribute_name
    'f'                 -- drop_column
);
-- approval IP address
select content_type__drop_attribute (
    'press',            -- content_type
    'approval_ip',      -- attribute_name
    'f'                 -- drop_column
);
-- delete content_type 'press'
select acs_object_type__drop_type (
    'press',            -- object_type
    't'                 -- cascade_p
);

-- drop indices to avoid lock situation through parent table

drop index cr_press_appuser_fk;

-- delete pertinent info from cr_press

drop table cr_press cascade;
drop table press_templates cascade;

-- delete privileges;

create function inline_0 ()
returns integer as '
declare
    default_context  acs_objects.object_id%TYPE;
    registered_users acs_objects.object_id%TYPE;
    the_public       acs_objects.object_id%TYPE;
begin
    perform acs_privilege__remove_child(''press_admin'',''press_approve'');
    perform acs_privilege__remove_child(''press_admin'',''press_create'');
    perform acs_privilege__remove_child(''press_admin'',''press_delete'');
    perform acs_privilege__remove_child(''press_admin'',''press_read'');
    perform acs_privilege__remove_child(''read'',''press_read'');
    perform acs_privilege__remove_child(''create'',''press_create'');
    perform acs_privilege__remove_child(''delete'',''press_delete'');
    perform acs_privilege__remove_child(''admin'',''press_approve'');
    perform acs_privilege__remove_child(''admin'',''press_admin'');		
    perform acs_privilege__drop_privilege(''press_admin'');

    default_context := acs__magic_object_id(''default_context'');
    the_public      := acs__magic_object_id(''the_public'');

    perform acs_permission__revoke_permission (
        default_context,        -- object_id
	the_public,             -- grantee_id
	''press_read''          -- privilege
    );

    perform acs_privilege__drop_privilege(''press_read'');
    perform acs_privilege__drop_privilege(''press_create'');
    perform acs_privilege__drop_privilege(''press_delete'');
    perform acs_privilege__drop_privilege(''press_approve'');

    return 0;
end;
' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();
