<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1</version></rdbms>

<fullquery name="week">      
      <querytext>
      select current_timestamp::date + $active_days from dual
      </querytext>
</partialquery>

</queryset>
