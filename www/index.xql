<?xml version="1.0"?>

<queryset>

<fullquery name="press_items">      
      <querytext>
    select   item_id,
             publication_name,
             publication_link,
             publication_date,
             publication_date_desc,
             article_title,
             article_abstract,
             article_link,
             article_pages,
             html_p,
             template_adp
    from     press_items_approved
    where    package_id = :package_id
    $view_clause
    order by publication_date desc
      </querytext>
</fullquery>

</queryset>
