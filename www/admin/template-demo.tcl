# /packages/press/www/template-demo.tcl

ad_page_contract {
    @author sarah@arsdigita.com
    @creation-date 2000-12-13
    @cvs-id $Id$
} -properties {
    table_of_templates:onevalue
}

# Loop over all of the available templates and produce a sample press
# item formatted according to the template specification.

set table_of_templates "<dl>"

press_item_sample

db_foreach template_list {
    select template_name, 
           template_adp 
    from   press_templates 
} {
    press_item_format

    append table_of_templates "<dt>$template_name</dt><dd>$template_value</dd>\n"
}

append table_of_templates "</dl>"




