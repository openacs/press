<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="press_items_archive.now">      
      <querytext>
      select sysdate from dual
      </querytext>
</fullquery>

<fullquery name="press_items_archive.next_week">      
      <querytext>
      select next_day(sysdate,'Monday') from dual
      </querytext>
</fullquery>

<fullquery name="press_items_archive.next_month">      
      <querytext>
      select add_months(sysdate,1) from dual
      </querytext>
</fullquery>

<fullquery name="press_items_archive.press_item_archive">      
      <querytext>
      begin
      press.archive(item_id => :id, archive_date => :archive_date);
      end;
      </querytext>
</fullquery>

<fullquery name="press_items_make_permanent.press_item_make_permanent">      
      <querytext>
      begin
      press.make_permanent(item_id => :id);
      end;
      </querytext>
</fullquery>

<fullquery name="press_items_delete.press_item_delete">      
      <querytext>
      begin
      press.del(item_id => :id);
      end;
      </querytext>
</fullquery>

</queryset>
