# /packages/press/www/template-edit-3.tcl

ad_page_contract {

    @author sarah@arsdigita.com
    @creation-date 2000-12-6
    @cvs-id $Id$

} {
    
    {template_id:integer ""}
    template_name:notnull
    template_adp:notnull,allhtml
    action:trim

}

set package_id [ad_conn package_id]

switch $action {

    edit {
	db_dml insert_template "
	update press_templates
	set    template_name = :template_name, 
      	       template_adp  = :template_adp
	where  template_id   = :template_id"
    }

    create {
	db_dml insert_template "
	insert into press_templates
	(template_id, template_name, template_adp)
	values
	(acs_object_id_seq.nextval, :template_name, :template_adp)"
    }

    default {
	ad_return_error "Invalid Action" "Valid actions are edit, create"
    }
}

ad_returnredirect template-admin
