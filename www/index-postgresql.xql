<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<partialquery name="view_clause_archive">      
      <querytext>
      and archive_date <= current_timestamp
      </querytext>
</partialquery>

<partialquery name="view_clause_live">      
      <querytext>
      and release_date <= current_timestamp
      and (archive_date > current_timestamp or archive_date is null)
      </querytext>
</partialquery>

<fullquery name="archive_count">      
      <querytext>
      select count(*)
        from press_items_approved
       where archive_date <= current_timestamp
      </querytext>
</fullquery>

</queryset>
