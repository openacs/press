<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="press_item_approve_release">      
      <querytext>
    begin
    press.approve_release(:revision_id,:release_date,:archive_date);
    end;
      </querytext>
</fullquery>

</queryset>
