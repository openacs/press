<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="update_press_revision">      
      <querytext>
    begin
    press.set_active_revision (:revision_id);
    end;
      </querytext>
</fullquery>

</queryset>
