# /packages/press/www/template-ae.tcl

ad_page_contract {
    
    This page serves a UI to add or edit a press template
    By default, the current template information is filled into the widgets
    If this is a new template, the default template is filled into the widgets
    Currently only Press Admin can do this.

    @author sarah@arsdigita.com
    @creation-date 2000-12-19
    @cvs-id $Id$
    
} {

    {template_id:integer ""}
    action:trim

} -properties {

    title:onevalue
    context:onevalue
    template_adp:onevalue
    template_name:onevalue
    hidden_vars:onevalue

}


# Permission to press_admin 

set package_id [ad_conn package_id]

# Are we creating a new template?

if [empty_string_p $template_id] {

    # Select the default template to initialize the form

    set template_name ""    
    set template_adp  [db_string press_template_default "
    select template_adp 
    from   press_templates 
    where  template_id = 1"]

} else {

    # Otherwise we need to select the appropriate info for this template

    db_1row press_item_info {
	select template_name,
               template_adp
	from   press_templates
	where  template_id = :template_id
    }
}

switch $action {
    edit {
	if { [string length $template_name] > 22 } {
	    set title "[string range $template_name 0 21]... : Edit template"
	} else {
	    set title "$template_name : Edit template"
	}
	set hidden_vars [export_form_vars template_id action]
	set small_action "edit"
	set descriptor   "current"
    }

    create {
	set title "Add a template"
	set hidden_vars [export_form_vars action]
	set small_action "create"
	set descriptor   "default"
    }

    default {
	ad_return_error "Invalid action" "Valid actions are edit and create"
	return
    }
}

set context [list $title]

ad_return_template
