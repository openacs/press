<?xml version="1.0"?>

<queryset>

<fullquery name="itemlist">      
      <querytext>
select item_id,
       press_id,
       publication_name,
       article_title,
       release_date,
       status
  from press_items
 where package_id = :package_id 
 order by $orderby desc
      </querytext>
</fullquery>

</queryset>
