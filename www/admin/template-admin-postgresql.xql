<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="press_templates">      
      <querytext>
    select t.template_id,
           t.template_name,
           t.template_adp,
           count(p.template_id) as template_usage
    from   press_templates t left outer join press_items_approved p using (template_id)
    group  by t.template_id, t.template_name, t.template_adp
    order  by t.template_name
      </querytext>
</fullquery>

</queryset>
