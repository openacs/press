<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="press_folder_id">      
      <querytext>
      select content_item__get_id('press',null,'f')
      </querytext>
</fullquery>

<fullquery name="object_id">      
      <querytext>
      select acs_object_id_seq.nextval
      </querytext>
</fullquery>

<fullquery name="datestring">      
      <querytext>
      select to_char(timestamp 'today', 'YYYYMMDD')
      </querytext>
</fullquery>

<fullquery name="create_press_item">      
      <querytext>
  select press__new (
    :name,                      -- name
    :publication_name,          -- publication_name
    :publication_link,          -- publication_link
    :publication_date,          -- publication_date
    :publication_date_desc,     -- publication_date_desc
    :article_link,              -- article_link
    :article_pages,             -- article_pages
    :html_p,                    -- article_abstract_html_p
    :approval_user,             -- approval_user
    :approval_date,             -- approval_date
    :approval_ip,               -- approval_ip
    :release_date,              -- release_date
    :archive_date,              -- archive_date
    :package_id,                -- package_id
    :parent_id,                 -- parent_id
    :item_id,                   -- item_id
    null,                       -- locale
    'content_item',             -- item_subtype
    'press',                    -- content_type
    :article_title,             -- title
    :article_abstract,          -- description
    :mime_type,                 -- mime_type
    :template_id,               -- template_id
    null,                       -- nls_language
    :txt,                       -- text
    null,                       -- relation_tag
    :live_revision_p,           -- is_live_p
    :creation_date,             -- creation_date
    :creation_ip,               -- creation_ip
    :creation_user              -- creation_user
)
      </querytext>
</fullquery>

</queryset>


