# /packages/press/www/template-ae-2.tcl

ad_page_contract {

    @author sarah@arsdigita.com
    @creation-date 2000-12-19
    @cvs-id $Id$

} {
    
    {template_id:integer ""}
    template_name:notnull
    template_adp:notnull,allhtml
    action:trim

} -properties {

    title:onevalue
    context:onevalue
    template_name:onevalue
    template_value:onevalue
    hidden_vars:onevalue

}

set package_id [ad_conn package_id]

set title "Preview Press Template"
set context [list "$title"]

# set variables to test case as in template-demo

press_item_sample
press_item_format

if [string equal $action edit] {
    set hidden_vars [export_form_vars template_name template_adp template_id action]
} else {
    set hidden_vars [export_form_vars template_name template_adp action]
}

ad_return_template

