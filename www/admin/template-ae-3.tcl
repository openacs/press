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
	db_dml edit_template {}
    }

    create {
	db_dml insert_template {}
    }

    default {
	ad_return_error "Invalid Action" "Valid actions are edit, create"
        ad_script_abort
    }
}

ad_returnredirect template-admin
