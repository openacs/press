<?xml version="1.0"?>

<queryset>
<fullquery name="reset_press_templates">      
      <querytext>
      update cr_press
         set template_id = (select template_id from press_templates where template_name='Default')
       where template_id = :template_id
      </querytext>
</fullquery>

<fullquery name="delete_template">      
      <querytext>
      delete from press_templates
       where template_id = :template_id
      </querytext>
</fullquery>

</queryset>
