# /packages/press/www/template-edit.tcl

ad_page_contract {
    
    This page servers a UI to edit a press template
    By default, the current template information is filled into the widgets
    Currently only Press Admin can do this.

    @author sarah@arsdigita.com
    @creation-date 12-6-2000
    @cvs-id $Id$
    
} {

    template_id:integer,notnull

} -properties {

    title:onevalue
    context:onevalue
    template_adp:onevalue
    template_name:onevalue
    template_value:onevalue
    hidden_vars:onevalue

}

set package_id [ad_conn package_id]

db_1row template_select {}

# Generate the preview

press_item_sample
press_item_format

if { [string length $template_name] > 22 } {
    set title "[string range $template_name 0 21]... : Delete template"
} else {
    set title "$template_name : Delete template"
}

set context [list $title]

set hidden_vars [export_form_vars template_id]

ad_return_template
