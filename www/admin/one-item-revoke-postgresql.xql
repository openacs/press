<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="press_item_revoke_release">      
      <querytext>
    select press__approve (
       :revision_id,    -- press_id
       :approve_p       -- approve_p
    )
      </querytext>
</fullquery>

</queryset>
