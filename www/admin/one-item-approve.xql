<?xml version="1.0"?>

<queryset>

<fullquery name="press_item_info">      
      <querytext>
    select creation_ip as item_creation_ip,
           creation_date as item_creation_date,
           publication_name,
           publication_link,
           publication_date,
           publication_date_desc,
           template_id,
           template_adp,
           article_title,
           article_abstract,
           article_link,
           article_pages,
           html_p,
           item_creator
      from press_item_revisions
     where revision_id = :revision_id
      </querytext>
</fullquery>

</queryset>
