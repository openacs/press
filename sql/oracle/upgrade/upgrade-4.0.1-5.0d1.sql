-- /packages/press/sql/press-create.sql
--
-- @author sarah@arsdigita.com
-- @author stefan@arsdigita.com
-- @author ron@arsdigita.com
--
-- @created 2000-11-15
--
-- $Id$


-- *** PACKAGE PRESS, plsql to create content_item ***
create or replace package press
as 
    function new (
        name                    in cr_items.name%TYPE,
        publication_name        in cr_press.publication_name%TYPE,
        publication_link        in cr_press.publication_link%TYPE default null,
        publication_date        in cr_press.publication_date%TYPE,
        publication_date_desc   in cr_press.publication_date_desc%TYPE default null,
        article_link            in cr_press.article_link%TYPE  default null,
        article_pages           in cr_press.article_pages%TYPE default null,
        article_abstract_html_p in cr_press.article_abstract_html_p%TYPE,
        approval_user           in cr_press.approval_user%TYPE default null,
        approval_date           in cr_press.approval_date%TYPE default null,
        approval_ip             in cr_press.approval_ip%TYPE   default null,
        release_date            in cr_press.release_date%TYPE  default null,
        archive_date            in cr_press.archive_date%TYPE default null,
        package_id              in cr_press.package_id%TYPE default null,
        parent_id               in acs_objects.context_id%TYPE default null,
        item_id                 in cr_items.item_id%TYPE default null,
        locale                  in cr_items.locale%TYPE default null,
        item_subtype            in acs_object_types.object_type%TYPE default 'content_item',
        content_type            in acs_object_types.object_type%TYPE default 'press',
        title                   in cr_revisions.title%TYPE default null,
        description             in cr_revisions.description%TYPE default null,
        mime_type               in cr_revisions.mime_type%TYPE default 'text/plain',
        template_id             in press_templates.template_id%TYPE default 1,
        nls_language            in cr_revisions.nls_language%TYPE default null,
        text                    in varchar2 default null,
        relation_tag            in cr_child_rels.relation_tag%TYPE default null,
        is_live_p               in varchar2 default 'f',
        creation_date           in acs_objects.creation_date%TYPE default sysdate,
        creation_ip             in acs_objects.creation_ip%TYPE default null,
        creation_user           in acs_objects.creation_user%TYPE default null
    ) return cr_press.press_id%TYPE;

    procedure del (
        item_id in cr_items.item_id%TYPE
    );  

    procedure make_permanent (
        item_id in cr_items.item_id%TYPE
    );

    procedure archive (
        item_id in cr_items.item_id%TYPE,
        archive_date in cr_press.archive_date%TYPE default sysdate
    );  

    -- administrative procs
    procedure approve (
        press_id in cr_press.press_id%TYPE,
        approve_p in varchar2 default 't'
    );

    procedure approve_release(    
        revision_id in cr_revisions.revision_id%TYPE,
        release_date in cr_press.release_date%TYPE,
        archive_date in cr_press.archive_date%TYPE
    );


    procedure set_active_revision(      
        revision_id in cr_revisions.revision_id%TYPE
    );


    function is_live (
        press_id in cr_press.press_id%TYPE
    ) return varchar;

    function status (
        press_id in cr_press.press_id%TYPE
    ) return varchar;

end press;
/
show errors


create or replace package body press
as function new (
        name                    in cr_items.name%TYPE,
        publication_name        in cr_press.publication_name%TYPE,
        publication_link        in cr_press.publication_link%TYPE default null,
        publication_date        in cr_press.publication_date%TYPE,
        publication_date_desc   in cr_press.publication_date_desc%TYPE default null,
        article_link            in cr_press.article_link%TYPE  default null,
        article_pages           in cr_press.article_pages%TYPE default null,
        article_abstract_html_p in cr_press.article_abstract_html_p%TYPE,
        approval_user           in cr_press.approval_user%TYPE default null,
        approval_date           in cr_press.approval_date%TYPE default null,
        approval_ip             in cr_press.approval_ip%TYPE   default null,
        release_date            in cr_press.release_date%TYPE  default null,
        archive_date            in cr_press.archive_date%TYPE default null,
        package_id              in cr_press.package_id%TYPE default null,
        parent_id               in acs_objects.context_id%TYPE default null,
        item_id                 in cr_items.item_id%TYPE default null,
        locale                  in cr_items.locale%TYPE default null,
        item_subtype            in acs_object_types.object_type%TYPE default 'content_item',
        content_type            in acs_object_types.object_type%TYPE default 'press',
        title                   in cr_revisions.title%TYPE default null,
        description             in cr_revisions.description%TYPE default null,
        mime_type               in cr_revisions.mime_type%TYPE default 'text/plain',
        template_id             in press_templates.template_id%TYPE default 1,
        nls_language            in cr_revisions.nls_language%TYPE default null,
        text                    in varchar2 default null,
        relation_tag            in cr_child_rels.relation_tag%TYPE default null,
        is_live_p               in varchar2 default 'f',
        creation_date           in acs_objects.creation_date%TYPE default sysdate,
        creation_ip             in acs_objects.creation_ip%TYPE default null,
        creation_user           in acs_objects.creation_user%TYPE default null
    ) return cr_press.press_id%TYPE
  is
    v_press_id    integer;
    v_item_id     integer;
    v_revision_id integer;
  begin
    v_item_id := content_item.new(
        name          => name,
        parent_id     => parent_id,
        item_id       => item_id,
        locale        => locale,
        item_subtype  => item_subtype,
        content_type  => content_type,
        mime_type     => mime_type,
        nls_language  => nls_language,
        relation_tag  => relation_tag,
        creation_date => creation_date,
        creation_ip   => creation_ip,
        creation_user => creation_user
    );

    v_revision_id := content_revision.new(
        title         => title,
        description   => description,
        mime_type     => mime_type,
        nls_language  => nls_language,
        text          => text,
        item_id       => v_item_id,
        creation_date => creation_date,
        creation_ip   => creation_ip,
        creation_user => creation_user
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
         archive_date);

    -- make this revision live when immediately approved

    if is_live_p = 't' then
        content_item.set_live_revision (v_revision_id);
    end if;

    return v_revision_id;
  end new;

  -- deletes a press item along with all its revisions

  procedure del ( 
      item_id in cr_items.item_id%TYPE
  )
  is
  begin
    delete 
    from  cr_press 
    where press_id in (select revision_id 
                       from   cr_revisions 
                       where  item_id = press.del.item_id);

    content_item.del( item_id => press.del.item_id );
  end del;

  -- make a press item permanent by nulling the archive_date 
  -- this only applies to the currently active revision
  procedure make_permanent (
    item_id in cr_items.item_id%TYPE
  )
  is
  begin 
    update cr_press
    set    archive_date = null
    where  press_id     = content_item.get_live_revision(press.make_permanent.item_id);
  end make_permanent;
 

  -- archive a press item by setting cr_press.release_date to sysdate
  -- this only applies to the currently active revision

  procedure archive (
    item_id      in cr_items.item_id%TYPE,
    archive_date in cr_press.archive_date%TYPE default sysdate  
  )
  is
  begin
    update cr_press     
    set    archive_date = press.archive.archive_date
    where  press_id     = content_item.get_live_revision(press.archive.item_id);
  end archive;

  -- approve/unapprove currently active revision

  procedure approve (
    press_id  in cr_press.press_id%TYPE,
    approve_p in varchar2 default 't'
  )
  is
      v_item_id cr_items.item_id%TYPE;
  begin
    if press.approve.approve_p = 't' then
        -- approve revision
        content_item.set_live_revision (
            revision_id => press_id
        );
        -- set approval_date for revision
        update cr_press 
        set    approval_date = sysdate
        where  press_id      = press.approve.press_id;
    else
        -- get item_id for revision that is being unapproved
        select item_id into v_item_id 
           from cr_revisions 
           where revision_id = press_id;
        -- unapprove revision
        -- does not mean to knock out active revision
        -- content_item.unset_live_revision (
        --    item_id => v_item_id
        -- );
        -- null approval_date for revision
        update cr_press 
           set approval_date = null,
               release_date = null
           where press_id = press.approve.press_id;
    end if;
  end approve;


  procedure approve_release(    
        revision_id in cr_revisions.revision_id%TYPE,
        release_date in cr_press.release_date%TYPE,
        archive_date in cr_press.archive_date%TYPE
    )
  is
  begin
    update cr_press
      set release_date = press.approve_release.release_date,
          archive_date = press.approve_release.archive_date
        where press_id = press.approve_release.revision_id;
   end approve_release;


  procedure set_active_revision(        
        revision_id in cr_revisions.revision_id%TYPE
  ) is
    v_press_item_p char;
    -- could be used to check if really a 'press' item
  begin
      content_item.set_live_revision (
          revision_id => press.set_active_revision.revision_id
      );
  end set_active_revision; 
        

  function is_live (
    press_id in cr_press.press_id%TYPE
  ) return varchar
  is
    v_item_id cr_items.item_id%TYPE;
  begin
    select item_id into v_item_id 
        from cr_revisions 
        where revision_id = press.is_live.press_id;
    -- use get_live_revision
    if content_item.get_live_revision(v_item_id) = press.is_live.press_id then
        return 't';
    else
        return 'f';
    end if;
  end is_live;


  -- the status function returns information on the publish or archive status
  -- it does not make any checks on the order of release_date and archive_date
  function status (
        press_id in cr_press.press_id%TYPE
  ) return varchar
  is
    v_archive_date date;
    v_release_date date;
  begin
    -- populate variables
    select 
         archive_date, release_date
      into 
         v_archive_date, v_release_date 
      from cr_press 
      where 
        press_id = press.status.press_id;

    -- if release_date is not null the item is approved, otherwise it is not
    -- archive_date can be null
    if v_release_date is not null then
      if v_release_date - sysdate > 0 then
        -- to be published (2 cases)
        if v_archive_date is null then 
          return 'going live in ' || 
                  round(to_char(v_release_date - sysdate),0) || ' days';
        else 
          return 'going live in ' || 
                  round(to_char(v_release_date - sysdate),1) || ' days' ||
                 ', archived in ' || round(to_char(v_archive_date - sysdate),0) || ' days';
        end if;  
      else
        -- already released or even archived (3 cases)
        if v_archive_date is null then
           return 'live, permanent';
        else
           if v_archive_date - sysdate > 0 then
             return 'live, archived in ' || 
                    round(to_char(v_archive_date - sysdate),0) || ' days';
           else 
             return 'archived';
           end if;
        end if;
      end if;     
    else 
        return 'unapproved';
    end if;
  end status;

end press;
/
show errors


-- *** PACKAGE PRESS_REVISION, plsql to update press items

-- press_revision: the basic idea here is to create a new press_revision
-- in both, cr_revision and cr_press for each edit, i.e. you can't edit a press revision after
-- upload, so that all changes are audited.
--
-- plsql to create revisions of press items
create or replace package press_revision
  as
  function new (
      title                     in cr_revisions.title%TYPE,
      description               in cr_revisions.description%TYPE default null,
      publish_date              in cr_revisions.publish_date%TYPE 
                                    default sysdate,
      mime_type                 in cr_revisions.mime_type%TYPE 
                                    default 'text/plain',
      nls_language              in cr_revisions.nls_language%TYPE
                                    default null,
      text                      in varchar2,
      item_id                   in cr_items.item_id%TYPE,
      creation_date             in acs_objects.creation_date%TYPE
                                    default sysdate,
      creation_user             in acs_objects.creation_user%TYPE
                                    default null,
      creation_ip               in acs_objects.creation_ip%TYPE default null,
      package_id                in cr_press.package_id%TYPE default null,
      publication_name          in cr_press.publication_name%TYPE,
      publication_link          in cr_press.publication_link%TYPE default null,
      publication_date          in cr_press.publication_date%TYPE,
      publication_date_desc     in cr_press.publication_date_desc%TYPE 
                                    default null,
      article_link              in cr_press.article_link%TYPE default null,
      article_pages             in cr_press.article_pages%TYPE default null,
      article_abstract_html_p   in cr_press.article_abstract_html_p%TYPE,
      approval_user             in cr_press.approval_user%TYPE default null,
      approval_date             in cr_press.approval_date%TYPE default null,
      approval_ip               in cr_press.approval_ip%TYPE
                                    default null,
      release_date              in cr_press.release_date%TYPE
                                    default sysdate,
      archive_date              in cr_press.archive_date%TYPE default null,
      template_id               in press_templates.template_id%TYPE default 1,
      make_active_revision_p    in varchar2 default 'f'
    ) return cr_revisions.revision_id%TYPE;

    procedure del (
      revision_id in cr_revisions.revision_id%TYPE
    );
end press_revision;
/
show errors


create or replace package body press_revision
  as
  function new (
      title                     in cr_revisions.title%TYPE,
      description               in cr_revisions.description%TYPE default null,
      publish_date              in cr_revisions.publish_date%TYPE 
                                    default sysdate,
      mime_type                 in cr_revisions.mime_type%TYPE 
                                    default 'text/plain',
      nls_language              in cr_revisions.nls_language%TYPE
                                    default null,
      text                      in varchar2,
      item_id                   in cr_items.item_id%TYPE,
      creation_date             in acs_objects.creation_date%TYPE
                                    default sysdate,
      creation_user             in acs_objects.creation_user%TYPE
                                    default null,
      creation_ip               in acs_objects.creation_ip%TYPE default null,
      package_id                in cr_press.package_id%TYPE default null,
      publication_name          in cr_press.publication_name%TYPE,
      publication_link          in cr_press.publication_link%TYPE default null,
      publication_date          in cr_press.publication_date%TYPE,
      publication_date_desc     in cr_press.publication_date_desc%TYPE 
                                    default null,
      article_link              in cr_press.article_link%TYPE default null,
      article_pages             in cr_press.article_pages%TYPE default null,
      article_abstract_html_p   in cr_press.article_abstract_html_p%TYPE,
      approval_user             in cr_press.approval_user%TYPE default null,
      approval_date             in cr_press.approval_date%TYPE default null,
      approval_ip               in cr_press.approval_ip%TYPE
                                    default null,
      release_date              in cr_press.release_date%TYPE
                                    default sysdate,
      archive_date              in cr_press.archive_date%TYPE default null, 
      template_id               in press_templates.template_id%TYPE default 1,
      make_active_revision_p    in varchar2 default 'f'
  ) return cr_revisions.revision_id%TYPE
  is
      v_revision_id    integer;
  begin

    -- create revision

    v_revision_id := content_revision.new(
        title         => title,
        description   => description,
        publish_date  => publish_date,
        mime_type     => mime_type,
        nls_language  => nls_language,
        text          => text,
        item_id       => item_id,
        creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip
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
         archive_date);

   -- make active revision if indicated

      if make_active_revision_p = 't' then
            press.set_active_revision(v_revision_id);
      end if;

  return v_revision_id;
  end new;

  procedure del (
    revision_id in cr_revisions.revision_id%TYPE
  )
  is
  begin

    delete from cr_press where press_id = press_revision.del.revision_id;

    content_revision.del(press_revision.del.revision_id);

  end del;
end press_revision;
/
show errors

