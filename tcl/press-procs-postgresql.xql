<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="press_items_archive.now">      
      <querytext>
      select current_timestamp
      </querytext>
</fullquery>

<fullquery name="press_items_archive.next_week">      
      <querytext>
      select (
        case when EXTRACT(DOW FROM TIMESTAMP 'today') = 0
        then 
          to_char('now'::date + '1 day'::interval,'YYYY-MM-DD HH:MM:SS')
        when EXTRACT(DOW FROM TIMESTAMP 'today') = 1
        then
          to_char('now'::date,'YYYY-MM-DD')
        when EXTRACT(DOW FROM TIMESTAMP 'today') = 2
        then
          to_char('now'::date + '6 days'::interval,'YYYY-MM-DD HH:MM:SS')
        when EXTRACT(DOW FROM TIMESTAMP 'today') = 3
        then
          to_char('now'::date + '5 days'::interval,'YYYY-MM-DD HH:MM:SS')
        when EXTRACT(DOW FROM TIMESTAMP 'today') = 4
        then
          to_char('now'::date + '4 days'::interval,'YYYY-MM-DD HH:MM:SS')
        when EXTRACT(DOW FROM TIMESTAMP 'today') = 5
        then
          to_char('now'::date + '3 days'::interval,'YYYY-MM-DD HH:MM:SS')
        when EXTRACT(DOW FROM TIMESTAMP 'today') = 6
        then
          to_char('now'::date + '2 days'::interval,'YYYY-MM-DD HH:MM:SS')
        end) as next_week
      </querytext>
</fullquery>

<fullquery name="press_items_archive.next_month">      
      <querytext>
      select to_char('now'::date + '1 month'::interval,'YYYY-MM-DD HH:MM:SS')
      </querytext>
</fullquery>

<fullquery name="press_items_archive.press_item_archive">      
      <querytext>
      select press__archive(:id,:archive_date)
      </querytext>
</fullquery>

<fullquery name="press_items_make_permanent.press_item_make_permanent">      
      <querytext>
      select press__make_permanent(:id)
      </querytext>
</fullquery>

<fullquery name="press_items_delete.press_item_delete">      
      <querytext>
      select press__delete(:id)
      </querytext>
</fullquery>

</queryset>
