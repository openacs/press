<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="create_press_item_revision">      
      <querytext>
    select press_revision__new (
        :article_title,         -- title
        :article_abstract,      -- description
        :mime_type,             -- mime_type
        :txt,                   -- text
        :item_id,               -- item_id
        :creation_user,         -- creation_user
        :creation_ip,           -- creation_ip
        :package_id,            -- package_id
        :publication_name,      -- publication_name
        :publication_link,      -- publication_link
        :publication_date,      -- publication_date
        :publication_date_desc, -- publication_date_desc
        :article_link,          -- article_link
        :article_pages,         -- article_pages
        :html_p,                -- article_abstract_html_p
        :approval_user,         -- approval_user
        :approval_date,         -- approval_date
        :approval_ip,           -- approval_ip
        :release_date,          -- release_date
        :archive_date,          -- archive_date
        :template_id,           -- template_id
        :active_revision_p,     -- make_active_revision_p
        null          -- revision_note
    )
      </querytext>
</fullquery>

</queryset>
