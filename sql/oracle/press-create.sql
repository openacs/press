-- /packages/press/sql/press-create.sql
--
-- @author sarah@arsdigita.com
-- @author stefan@arsdigita.com
-- @author ron@arsdigita.com
--
-- @created 2000-11-15
--
-- $Id$

--
-- Permissions
--

begin
    -- the read privilege is by default granted to 'the_public'
    -- the site-wide administrator has to change this in /permissions/ 
    -- if he wants to restrict an instance to a specific party_id only

    -- the press_admin has all privileges, read, create, delete, approve
    -- it is a child of 'admin'

    acs_privilege.create_privilege('press_read');
    acs_privilege.create_privilege('press_create');
    acs_privilege.create_privilege('press_delete');
    acs_privilege.create_privilege('press_approve');

    -- bind privileges to global names  
    acs_privilege.add_child('read',   'press_read');
    acs_privilege.add_child('create', 'press_create');
    acs_privilege.add_child('delete', 'press_delete');
    acs_privilege.add_child('admin',  'press_approve');

    -- add this to the press_admin privilege
    acs_privilege.create_privilege('press_admin', 'Press administrator');

    -- press administrator binds to global 'admin', plus inherits press_* permissions
    acs_privilege.add_child('admin',      'press_admin');       
    acs_privilege.add_child('press_admin','press_approve');
    acs_privilege.add_child('press_admin','press_create');
    acs_privilege.add_child('press_admin','press_delete');
end;
/
show errors

-- assign permission to defined contexts within ACS by default
--
declare
    default_context acs_objects.object_id%TYPE;
    registered_users acs_objects.object_id%TYPE;
    the_public acs_objects.object_id%TYPE;
begin
    default_context := acs.magic_object_id('default_context');
    registered_users := acs.magic_object_id('registered_users');
    the_public := acs.magic_object_id('the_public');
    

    -- give the public permission to read by default
    acs_permission.grant_permission (
        object_id  => default_context,
        grantee_id => the_public,
        privilege  => 'press_read'
    );


    -- outcomment if your site wants to 
    -- give registered users permission to upload items by default
    -- acs_permission.grant_permission (
    --    object_id  => default_context,
    --    grantee_id => registered_users,
    --    privilege  => 'press_create'
    -- );


end;
/
show errors

-- this table stores the different adp-templates to show a press item

create table press_templates (
    template_id        integer primary key not null,
    -- we use this to select the template
    template_name      varchar(100) not null unique,
    -- the adp code fragment
    template_adp       varchar2(4000) not null
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
    publication_name            varchar2(100)
                                constraint cr_press_publication_name_nn not null,
    publication_link            varchar2(200),
    -- *** the specific journal issue ***
    publication_date            date not null,
    publication_date_desc       varchar2(100),
    -- *** the article link, pages ***
    article_link                varchar2(400),
    article_pages               varchar2(40),
    article_abstract_html_p     varchar2(1) 
                                constraint cp_article_abstract_html_p_ck
                                check (article_abstract_html_p in ('t','f')),
    -- *** support for dates when items are displayed or archived ***
    -- unapproved release dates are null
    release_date                date,
    -- unscheduled archiving dates are null
    archive_date                date,
    -- support for approval, if ApprovalRequiredP == 1
    approval_user               integer
                                constraint cr_press_approval_user_fk
                                references users,
    approval_date               date,
    approval_ip                 varchar2(50),
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

insert 
into press_templates
    (template_id,       
     template_name,
     template_adp)
values
    (1,
     'Default',
     '<b>@publication_name@</b> - @article_title@<br> @publication_date@ : "@article_abstract@"');          

declare
    attr_id acs_attributes.attribute_id%TYPE;
begin

content_type.create_type (
    content_type  => 'press',
    pretty_name   => 'Press Item',
    pretty_plural => 'Press Items',
    table_name    => 'cr_press',
    id_column     => 'press_id'
);

-- create attributes for widget generation later

-- publication in which the press article appeared

attr_id := content_type.create_attribute (
    content_type   => 'press',
    attribute_name => 'publication_name',
    datatype       => 'text',
    pretty_name    => 'Publication',
    pretty_plural  => 'Publications',
    column_spec    => 'varchar2(100)'
);

-- URL link to this publication

attr_id := content_type.create_attribute (
    content_type   => 'press',
    attribute_name => 'publication_link',
    datatype       => 'text',
    pretty_name    => 'Publication URL',
    pretty_plural  => 'Publication URL',
    column_spec    => 'varchar2(200)'
);

-- issue date

attr_id := content_type.create_attribute (
    content_type   => 'press',
    attribute_name => 'publication_date',
    datatype       => 'date',
    pretty_name    => 'Publication Date',
    pretty_plural  => 'Publication Dates',
    column_spec    => 'date'
);

-- issue date in words (optional)

attr_id := content_type.create_attribute (
    content_type   => 'press',
    attribute_name => 'publication_date_desc',
    datatype       => 'text',
    pretty_name    => 'Publication Date Description',
    pretty_plural  => 'Publication Date Description',
    column_spec    => 'varchar2(100)'
);

-- URL link to the article 

attr_id := content_type.create_attribute (
    content_type   => 'press',
    attribute_name => 'article_link',
    datatype       => 'text',
    pretty_name    => 'Article Link',
    pretty_plural  => 'Article Links',
    column_spec    => 'varchar2(400)'
);

-- article page range, e.g. 'pp 83-100'

attr_id := content_type.create_attribute (
    content_type   => 'press',
    attribute_name => 'article_pages',
    datatype       => 'text',
    pretty_name    => 'Article Pages',
    pretty_plural  => 'Articles Pages',
    column_spec    => 'varchar2(40)'
);

-- a flag that tells if the article abstract is in HTML or not

attr_id := content_type.create_attribute (
    content_type   => 'press',
    attribute_name => 'article_abstract_html_p',
    datatype       => 'text',
    pretty_name    => 'Article Abstract HTML Flag',
    pretty_plural  => 'Article Abstract HTML Flag',
    column_spec    => 'varchar2(1)'
);

-- release date of press release

attr_id := content_type.create_attribute (
    content_type   => 'press',
    attribute_name => 'release_date',
    datatype       => 'timestamp',
    pretty_name    => 'Release Date',
    pretty_plural  => 'Release Dates',
    default_value  => sysdate,
    column_spec    => 'date'
);

-- archive date of press release

attr_id := content_type.create_attribute (
    content_type   => 'press',
    attribute_name => 'archive_date',
    datatype       => 'timestamp',
    pretty_name    => 'Archival Date',
    pretty_plural  => 'Archival Dates',
    column_spec    => 'date'
);

-- assignement to an authorized user for approval

attr_id := content_type.create_attribute (
    content_type   => 'press',
    attribute_name => 'approval_user',
    datatype       => 'integer',
    pretty_name    => 'Approval User',
    pretty_plural  => 'Approval Users',
    column_spec    => 'integer'
);

-- approval date

attr_id := content_type.create_attribute (
    content_type   => 'press',
    attribute_name => 'approval_date',
    datatype       => 'timestamp',
    pretty_name    => 'Approval Date',
    pretty_plural  => 'Approval Dates',
    default_value  => sysdate,
    column_spec    => 'date'
);

-- approval IP address

attr_id := content_type.create_attribute (
    content_type   => 'press',
    attribute_name => 'approval_ip',
    datatype       => 'text',
    pretty_name    => 'Approval IP',
    pretty_plural  => 'Approval IPs',
    column_spec    => 'varchar2'
);

end;
/
show errors

-- CREATE THE PRESS FOLDER as our CONTAINER ***

-- create 1 press folder; different instances are filtered by package_id
-- associate content types with press folder 

declare
    v_folder_id cr_folders.folder_id%TYPE;
begin
    v_folder_id := content_folder.new(
        name        => 'press',
        label       => 'press',
        description => 'Press Item Root Folder, all press items go in here'
    );
    content_folder.register_content_type (
        folder_id        => v_folder_id,
        content_type     => 'press',
        include_subtypes => 't'
    );
    content_folder.register_content_type (
        folder_id        => v_folder_id,
        content_type     => 'content_revision',
        include_subtypes => 't'
    );
end;
/
show errors


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


  -- the status function returns information on the pulish or archive status
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

--
-- views on cr_press that combine information from cr_press, cr_items, cr_revisions 
--

-- view of all press items in the system 

create or replace view press_items
as 
select ci.item_id as item_id,
       press_id,
       package_id,
       publication_name,
       publication_link,
       publication_date,
       publication_date_desc,
       cr.title as article_title,
       cr.description as article_abstract,
       article_link,
       article_pages,
       article_abstract_html_p,
       release_date,
       archive_date,
       live_revision,
       press.status(press_id) as status
from   cr_items ci, 
       cr_revisions cr,
       cr_press cp
where  (    ci.item_id       = cr.item_id
        and ci.live_revision = cr.revision_id 
        and cr.revision_id   = cp.press_id)
or     (    ci.live_revision is null 
        and ci.item_id       = cr.item_id
        and cr.revision_id   = content_item.get_latest_revision(ci.item_id)
        and cr.revision_id   = cp.press_id);

--  view on all approved press items (active revision only)

create or replace view press_items_approved
as
select ci.item_id as item_id,
       package_id,
       publication_name,
       publication_link,
       publication_date,
       publication_date_desc,
       cr.title as article_title,
       cr.description as article_abstract,
       article_link,
       article_pages,
       article_abstract_html_p as html_p,
       release_date,
       archive_date,
       pt.template_id,
       pt.template_name,
       pt.template_adp
from   cr_items ci, 
       cr_revisions cr,
       cr_press cp,
       press_templates pt       
where  ci.item_id       = cr.item_id
and    ci.live_revision = cr.revision_id
and    cr.revision_id   = cp.press_id
and    pt.template_id   = cp.template_id;

-- view of all revisions of a press item

create or replace view press_item_revisions
as 
select revision_id,
       cr.item_id as item_id,
       package_id,
       publication_name,
       publication_link,
       publication_date,
       publication_date_desc,
       cr.title as article_title,
       cr.description as article_abstract,
       article_link,
       article_pages,
       article_abstract_html_p as html_p,
       release_date,
       archive_date,
       cp.template_id,
       template_name,
       template_adp,
       creation_date,
       press.status(press_id) as status,
       first_names || ' ' || last_name as item_creator,
       creation_ip,
       ci.name as item_name
from   cr_revisions cr,
       cr_press cp,
       press_templates pt,
       cr_items ci,
       acs_objects ao,
       persons
where  cr.revision_id   = ao.object_id
and    cr.revision_id   = cp.press_id
and    cp.template_id   = pt.template_id
and    ci.item_id       = cr.item_id
and    ao.creation_user = persons.person_id;
