<?xml version="1.0"?>

<queryset>
<fullquery name="press_items">      
      <querytext>
  select item_id,
         package_id,
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
         release_date,
         archive_date,
         template_adp   
    from press_items_approved
   where item_id in ([join $pr_items ,])
     and package_id = :package_id
   order by publication_date desc 
      </querytext>
</fullquery>

</queryset>
