<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="press_item_approve_release">      
      <querytext>
      select press__approve_release(:revision_id,:release_date,:archive_date)
      </querytext>
</fullquery>

</queryset>
