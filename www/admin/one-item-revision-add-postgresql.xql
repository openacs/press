<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="item">      
      <querytext>
select pr.revision_id,
       publication_name,
       publication_link,
       publication_date as item_publication_date,
       publication_date_desc,
       article_title,
       article_link,
       article_pages,
       article_abstract,
       html_p as article_abstract_html_p,
       template_id,
       template_name,
       release_date as item_release_date,
       archive_date as item_archive_date,
       status
  from press_item_revisions pr
 where pr.item_id = :item_id
   and package_id = :package_id
   and content_revision__is_live(revision_id) = 't'
      </querytext>
</fullquery>

</queryset>
