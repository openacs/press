<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="update_press_revision">      
      <querytext>
      select press__set_active_revision (:revision_id)
      </querytext>
</fullquery>

</queryset>
