-- /packages/press/sql/press-delete.sql
--
-- @author sarah@arsdigita.com
-- @author stefan@arsdigita.com
-- @author ron@arsdigita.com
--
-- @created 2000-11-27
--
-- $Id$

drop package press_revision;
drop package press;

-- delete press views

drop view press_items_approved;
drop view press_item_revisions;

-- unregister content_types from folder

declare
    v_folder_id	cr_folders.folder_id%TYPE;
    v_item_id   cr_items.item_id%TYPE;
    CURSOR c_item_id IS
        SELECT item_id
        FROM cr_items
        WHERE parent_id = v_folder_id;
begin
    select content_item.get_id('press') into v_folder_id from dual;

-- delete all contents of press folder

    OPEN c_item_id;
    LOOP
        FETCH c_item_id into v_item_id;
        content_item.del(v_item_id);
        EXIT WHEN c_item_id%NOTFOUND;
    END LOOP;
    CLOSE c_item_id;

-- cheesy sub for cursor that doesn't work. need to fix.
-- update cr_items set parent_id=0 where parent_id = v_folder_id;
-- unregister_content_types

    content_folder.unregister_content_type (
        folder_id        => v_folder_id,
        content_type     => 'content_revision',
        include_subtypes => 't'
    );

    content_folder.unregister_content_type (
        folder_id        => v_folder_id,
        content_type     => 'press',
        include_subtypes => 't'
    );

    -- delete press folder

    content_folder.del(v_folder_id);

end;
/
show errors

-- drop attributes
begin
-- the Journal in which the press article appeared
content_type.drop_attribute (
    content_type   => 'press',
    attribute_name => 'publication_name'
);
-- the URL link to this Journal 
content_type.drop_attribute (
    content_type   => 'press',
    attribute_name => 'publication_link'
);
-- the journal issue date
content_type.drop_attribute (
    content_type   => 'press',
    attribute_name => 'publication_date'
);
-- the journal issue date in words
content_type.drop_attribute (
    content_type   => 'press',
    attribute_name => 'publication_date_desc'
);
-- the URL link to the article 
content_type.drop_attribute (
    content_type   => 'press',
    attribute_name => 'article_link'
);
-- the article page range, e.g. 'pp 83-100'
content_type.drop_attribute (
    content_type   => 'press',
    attribute_name => 'article_pages'
);
-- a flag that tells if the article abstract is in HTML or not
content_type.drop_attribute (
    content_type   => 'press',
    attribute_name => 'article_abstract_html_p'
);
-- website release date of press release
content_type.drop_attribute (
    content_type   => 'press',
    attribute_name => 'release_date'
);
-- website archive date of press release
content_type.drop_attribute (
    content_type   => 'press',
    attribute_name => 'archive_date'
);
-- assignment to an authorized user for approval
content_type.drop_attribute (
    content_type   => 'press',
    attribute_name => 'approval_user'
);
-- approval date
content_type.drop_attribute (
    content_type   => 'press',
    attribute_name => 'approval_date'
);
-- approval IP address
content_type.drop_attribute (
    content_type   => 'press',
    attribute_name => 'approval_ip'
);
-- delete content_type 'press'
acs_object_type.drop_type (
    object_type => 'press',
    cascade_p => 't'
);
end;
/
show errors

-- drop indices to avoid lock situation through parent table

drop index cr_press_appuser_fk;

-- delete pertinent info from cr_press

drop table cr_press;
drop table press_templates;

-- delete privileges;

declare
    default_context  acs_objects.object_id%TYPE;
    registered_users acs_objects.object_id%TYPE;
    the_public       acs_objects.object_id%TYPE;
begin
    acs_privilege.remove_child('press_admin','press_approve');
    acs_privilege.remove_child('press_admin','press_create');
    acs_privilege.remove_child('press_admin','press_delete');
    acs_privilege.remove_child('press_admin','press_read');
    acs_privilege.remove_child('read','press_read');
    acs_privilege.remove_child('create','press_create');
    acs_privilege.remove_child('delete','press_delete');
    acs_privilege.remove_child('admin','press_approve');
    acs_privilege.remove_child('admin','press_admin');		
    acs_privilege.drop_privilege('press_admin');

    default_context := acs.magic_object_id('default_context');
    the_public      := acs.magic_object_id('the_public');

    acs_permission.revoke_permission (
        object_id  => default_context,
	grantee_id => the_public,
	privilege  => 'press_read'
    );

    acs_privilege.drop_privilege('press_read');
    acs_privilege.drop_privilege('press_create');
    acs_privilege.drop_privilege('press_delete');
    acs_privilege.drop_privilege('press_approve');

end;
/
show errors




















