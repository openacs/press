<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<partialquery name="view_clause_archive">      
      <querytext>
      archive_date <= sysdate
      </querytext>
</partialquery>

<partialquery name="view_clause_live">      
      <querytext>
      and release_date <= sysdate
      and (archive_date > sysdate or archive_date is null)
      </querytext>
</partialquery>

<fullquery name="archive_count">      
      <querytext>
      select count(*)
        from press_items_approved
       where archive_date <= sysdate
      </querytext>
</fullquery>

</queryset>
