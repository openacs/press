-- /packages/press/sql/press-package-create.sql
--
-- @author sarah@arsdigita.com
-- @author stefan@arsdigita.com
-- @author ron@arsdigita.com
-- @author michael@steigman.net
--
-- @created 2003-10-23
--
-- $Id$

-- *** PACKAGE PRESS, plsql to create content_item ***

create function press__new (varchar,varchar,varchar,timestamptz,varchar,varchar,varchar,varchar,integer,timestamptz,varchar,timestamptz,timestamptz,integer,integer,integer,varchar,varchar,varchar,varchar,varchar,varchar,integer,varchar,varchar,varchar,varchar,timestamptz,varchar,integer)
returns integer as '
declare
    p_name                    alias for $1;
    p_publication_name        alias for $2;
    p_publication_link        alias for $3;
    p_publication_date        alias for $4;
    p_publication_date_desc   alias for $5;
    p_article_link            alias for $6;
    p_article_pages           alias for $7;
    p_article_abstract_html_p alias for $8;
    p_approval_user           alias for $9;
    p_approval_date           alias for $10;
    p_approval_ip             alias for $11;
    p_release_date            alias for $12;
    p_archive_date            alias for $13;
    p_package_id              alias for $14;
    p_parent_id               alias for $15;
    p_item_id                 alias for $16;
    p_locale                  alias for $17;
    p_item_subtype            alias for $18;
    p_content_type            alias for $19;
    p_title                   alias for $20;
    p_description             alias for $21;
    p_mime_type               alias for $22;
    p_template_id             alias for $23;
    p_nls_language            alias for $24;
    p_text                    alias for $25;
    p_relation_tag            alias for $26;
    p_is_live_p               alias for $27;
    p_creation_date           alias for $28;
    p_creation_ip             alias for $29;
    p_creation_user           alias for $30;
    v_press_id                integer;
    v_item_id                 integer;
    v_revision_id             integer;
    v_revision_log            varchar;
begin

    v_revision_log := ''initial submission'';
    v_item_id := content_item__new (
        p_name,           -- name
        p_parent_id,      -- parent_id
        p_item_id,        -- item_id
        p_locale,         -- locale
        current_timestamp,-- creation_date
        p_creation_user,  -- creation_user
        null,             -- context_id
        p_creation_ip,    -- creation_ip
        p_item_subtype,   -- item_subtype
        p_content_type,   -- content_type
        null,             -- title
        null,             -- description
        p_mime_type,      -- mime_type
        p_nls_language,   -- nls_language
        null,             -- data
        ''text''          -- storage_type
    );

    v_revision_id := content_revision__new (
        p_title,          -- title
        v_revision_log,   -- description
        p_release_date,   -- publish_date
        p_mime_type,      -- mime_type
        p_nls_language,   -- nls_language
        p_description,    -- content
        v_item_id,        -- item_id 
        null,             -- revision_id
        p_creation_date,  -- creation_date
        p_creation_user,  -- creation_user
        p_creation_ip     -- creation_ip
    );

    insert into cr_press 
        (press_id, 
         package_id,
         publication_name, 
         publication_date, 
         publication_date_desc, 
         publication_link, 
         article_link, 
         article_abstract_html_p, 
         article_pages, 
         template_id,
         approval_user, 
         approval_date,
         approval_ip, 
         release_date, 
         archive_date)
    values
        (v_revision_id, 
         p_package_id, 
         p_publication_name, 
         p_publication_date, 
         p_publication_date_desc, 
         p_publication_link, 
         p_article_link, 
         p_article_abstract_html_p, 
         p_article_pages, 
         p_template_id,
         p_approval_user, 
         p_approval_date, 
         p_approval_ip, 
         p_release_date, 
         p_archive_date);

    -- make this revision live when immediately approved

    if p_is_live_p = ''t'' then
        perform content_item__set_live_revision (v_revision_id);
    end if;

    return v_revision_id;

end;' language 'plpgsql';

  -- deletes a press item along with all its revisions

create function press__delete (integer)
returns integer as '
declare
    p_item_id alias for $1;
begin
    delete 
      from cr_press 
     where press_id in (select revision_id 
                          from cr_revisions 
                         where item_id = p_item_id);

    perform content_item__delete(p_item_id);

    return 0;

end;' language 'plpgsql';

-- make a press item permanent by nulling the archive_date 
-- this only applies to the currently active revision

create function press__make_permanent (integer)
returns integer as '
declare
    p_item_id alias for $1;
begin
    update cr_press
       set archive_date = null
     where press_id = content_item__get_live_revision(p_item_id);

    return 0;

end;' language 'plpgsql';

-- archive a press item by setting cr_press.release_date to sysdate
-- this only applies to the currently active revision

create function press__archive (integer,timestamptz)
returns integer as '
declare
    p_item_id alias for $1;
    p_archive_date alias for $2;
begin
    update cr_press     
       set archive_date = p_archive_date
     where press_id = content_item__get_live_revision(p_item_id);

    return 0;

end;' language 'plpgsql';

-- approve/unapprove currently active revision

create function press__approve (integer,varchar)
returns integer as '
declare
    p_press_id alias for $1;
    p_approve_p alias for $2;
    v_item_id cr_items.item_id%TYPE;
begin

    -- get item_id for revision that is being unapproved
    select item_id into v_item_id 
      from cr_revisions 
     where revision_id = p_press_id;

    if p_approve_p = ''t'' then
        -- approve revision
        perform content_item__set_live_revision (p_revision_id);

        -- set approval_date for revision
        update cr_press 
           set approval_date = current_timestamp
         where press_id = p_press_id;
    else
        -- unapprove revision
        -- does not mean to knock out active revision
        -- perform content_item__unset_live_revision (v_item_id);

        -- null approval_date for revision
        update cr_press 
           set approval_date = null,
               release_date = null
         where press_id = p_press_id;
    end if;

    return 0;

end;' language 'plpgsql';

create function press__approve_release (integer,timestamptz,timestamptz)
returns integer as '
declare
    p_revision_id alias for $1;
    p_release_date alias for $2;
    p_archive_date alias for $3;
begin
    update cr_press
       set release_date = p_release_date,
           archive_date = p_archive_date
     where press_id = p_revision_id;

    return 0;

end;' language 'plpgsql';

create function press__set_active_revision (integer)
returns integer as '
declare
    p_revision_id alias for $1;
    v_press_item_p char;
    -- could be used to check if really a press item
begin
    perform content_item__set_live_revision (p_revision_id);

    return 0;

end;' language 'plpgsql';

create function press__is_live (integer)
returns varchar as '
declare
    p_press_id alias for $1;
    v_item_id cr_items.item_id%TYPE;
begin
    select item_id into v_item_id 
      from cr_revisions 
     where revision_id = p_press_id;
    -- use get_live_revision
    if content_item__get_live_revision(v_item_id) = p_press_id then
        return ''t'';
    else
        return ''f'';
    end if;
 
end;' language 'plpgsql';

-- the status function returns information on the publish or archive status
-- it does not make any checks on the order of release_date and archive_date

create function press__status (integer)
returns varchar as '
declare
    p_press_id alias for $1;
    v_archive_date date;
    v_release_date date;
begin
    -- populate variables
    select archive_date, release_date
      into v_archive_date, v_release_date 
      from cr_press 
     where press_id = p_press_id;

    -- if release_date is not null the item is approved, otherwise it is not
    -- archive_date can be null
    if v_release_date is not null then
      if v_release_date > current_timestamp then
        -- to be published (2 cases)
        if v_archive_date is null then 
          return ''going live in ''
          || text(round(cast(extract(days from (v_release_date - current_timestamp))
          + extract(hours from (v_release_date - current_timestamp))/24 as numeric),1))
	  || '' days'';
        else 
          return ''going live in ''
          || text(round(cast(extract(days from (v_release_date - current_timestamp))
          + extract(hours from (v_release_date - current_timestamp))/24 as numeric),1))
          || '' days'' || '', archived in ''
          || text(round(cast(extract(days from (v_archive_date - current_timestamp))
	  + extract(hours from (v_archive_date - current_timestamp))/24 as numeric),1))
          || '' days'';
        end if;  
      else
        -- already released or even archived (3 cases)
        if v_archive_date is null then
           return ''live, permanent'';
        else
           if v_archive_date > current_timestamp then
            return ''live, archived in ''
            || text(round(cast(extract(days from (v_archive_date - current_timestamp))
            + extract(hours from (v_archive_date - current_timestamp))/24 as numeric),1))
            || '' days'';
           else 
             return ''archived'';
           end if;
        end if;
      end if;     
    else 
        return ''unapproved'';
    end if;

end;' language 'plpgsql';

-- *** PACKAGE PRESS_REVISION, plsql to update press items

-- press_revision: the basic idea here is to create a new press_revision
-- in both, cr_revision and cr_press for each edit, i.e. you can't edit a press revision after
-- upload, so that all changes are audited.
--
-- plsql to create revisions of press items

create function press_revision__new (varchar,varchar,varchar,varchar,integer,integer,varchar,integer,varchar,varchar,timestamptz,varchar,varchar,varchar,varchar,integer,timestamptz,varchar,timestamptz,timestamptz,integer,varchar,varchar)
returns integer as '
declare
    p_title                     alias for $1;
    p_description               alias for $2;
    p_mime_type                 alias for $3;
    p_text                      alias for $4;
    p_item_id                   alias for $5;
    p_creation_user             alias for $6;
    p_creation_ip               alias for $7;
    p_package_id                alias for $8;
    p_publication_name          alias for $9;
    p_publication_link          alias for $10;
    p_publication_date          alias for $11;
    p_publication_date_desc     alias for $12;
    p_article_link              alias for $13;
    p_article_pages             alias for $14;
    p_article_abstract_html_p   alias for $15;
    p_approval_user             alias for $16;
    p_approval_date             alias for $17;
    p_approval_ip               alias for $18;
    p_release_date              alias for $19;
    p_archive_date              alias for $20;
    p_template_id               alias for $21;
    p_make_active_revision_p    alias for $22;
    p_revision_note             alias for $23;
    v_revision_id               integer;
begin

    -- create revision
    v_revision_id := content_revision__new (
        p_title,          -- title
        p_revision_note,  -- description
        p_release_date,   -- publish_date
        p_mime_type,      -- mime_type 
        null,             -- nls_language
        p_description,    -- content
        p_item_id,        -- item_id
        null,             -- revision_id
        current_timestamp,-- creation_date
        p_creation_user,  -- creation_user
        p_creation_ip     -- creation_ip
    );

    -- create new press entry to go with new revision

    insert into cr_press
        (press_id, 
         package_id, 
         publication_name, 
         publication_date, 
         template_id,
         publication_date_desc, 
         publication_link, 
         article_link, 
         article_pages, 
         article_abstract_html_p, 
         approval_user, 
         approval_date, 
         approval_ip, 
         release_date, 
         archive_date)
    values
        (v_revision_id, 
         p_package_id, 
         p_publication_name, 
         p_publication_date, 
         p_template_id,
         p_publication_date_desc, 
         p_publication_link, 
         p_article_link, 
         p_article_pages, 
         p_article_abstract_html_p, 
         p_approval_user, 
         p_approval_date, 
         p_approval_ip, 
         p_release_date, 
         p_archive_date);

   -- make active revision if indicated

      if p_make_active_revision_p = ''t'' then
            perform press__set_active_revision(v_revision_id);
      end if;

  return v_revision_id;

end;' language 'plpgsql';

create function press_revision__delete (integer)
returns varchar as '
declare
    p_revision_id alias for $1;
begin

    delete from cr_press where press_id = p_revision_id;

    perform content_revision__delete(p_revision_id);
    
    return 0;

end;' language 'plpgsql';
