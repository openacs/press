<?xml version="1.0"?>

<queryset>

<fullquery name="edit_template">      
      <querytext>
	update press_templates
	   set template_name = :template_name, 
      	       template_adp  = :template_adp
	 where template_id   = :template_id
      </querytext>
</fullquery>

<fullquery name="insert_template">      
      <querytext>
	insert into press_templates
	(template_id, template_name, template_adp)
	values
	(acs_object_id_seq.nextval, :template_name, :template_adp)
      </querytext>
</fullquery>

</queryset>
