<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="week">      
      <querytext>
      select to_char(current_timestamp + '$days_until_archival days'::interval, 'YYYY-MM-DD HH:MM:SS') from dual
      </querytext>
</fullquery>

</queryset>
