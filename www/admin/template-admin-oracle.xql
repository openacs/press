<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="press_templates">      
      <querytext>
    select t.template_id,
           t.template_name,
           t.template_adp,
           count(p.template_id) as template_usage
    from   press_templates t, 
           press_items_approved p
    where  t.template_id = p.template_id(+)
    group  by t.template_id, t.template_name, t.template_adp
    order  by t.template_name
      </querytext>
</fullquery>

</queryset>
