# /packages/press/www/admin/template-admin.tcl

ad_page_contract {

    UI for press_admin to create/edit/delete press templates

    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date December 8, 2000
    @cvs-id $Id$

} {
} -properties {
    title:onevalue
    context:onevalue
    template_list:onevalue
}

set title "Press Templates"
set context [list $title]

set template_list [list]

# Grab the sample information


db_foreach press_templates {} {

    set template_item "
    <li>$template_name (used $template_usage time[expr {$template_usage != 1 ? "s" : ""}])
    &nbsp; 
    <a href=template-ae?action=edit&template_id=$template_id>edit</a>"

    if {$template_usage == 0 && $template_id > 1} {
	append template_item \
		" | <a href=template-delete?template_id=$template_id>delete</a>"
    }
    
    # Generate a preview

    press_item_sample
    press_item_format

    lappend template_list "$template_item <blockquote> $template_value </blockquote>"
}

ad_return_template
