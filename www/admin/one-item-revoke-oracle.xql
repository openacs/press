<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="press_item_revoke_release">      
      <querytext>
    begin
    press.approve(
    press_id => :revision_id,
    approve_p => :approve_p
    );
    end;
      </querytext>
</fullquery>

</queryset>
