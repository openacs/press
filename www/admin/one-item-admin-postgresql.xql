<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="item_revs_list">      
      <querytext>
    select item_id,
           revision_id,
           publication_name,
           publication_link,
           publication_date,
           publication_date_desc,
           article_title,
           article_link,
           article_pages,
           article_abstract,
           html_p,
           creation_date,
           status,
           item_creator,
           creation_ip,
           case when status = 'unapproved'then 0 else 1 end as approved_p,
           template_id,
           template_adp,
           null as template_value,
           case when content_revision__is_live(revision_id) = 't' then 1 else 0 end as is_live_p
      from press_item_revisions
     where item_id = :item_id
       and package_id = :package_id
     order by revision_id desc
      </querytext>
</fullquery>

</queryset>
