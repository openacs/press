# /packages/press/www/process.tcl

ad_page_contract {

    This is the target from the Form on the bottom of administer.adp
    It processes the commands 'Delete','Archive','Make Permanent'    
    Definitely only restricted to Press Admin

    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date November 24, 2000
    @cvs-id $Id$
    
} {
 
    pr_items:multiple,notnull
    action:notnull

} -errors {

    pr_items:notnull "Please check the items which you want to have processed."

} -properties {

    title:onevalue
    context:onevalue
    action:onevalue
    hidden_vars:onevalue
    unapproved:multirow
    halt_p:onevalue
    pr_items:onevalue
    templated_list:onevalue
}


set package_id [ad_conn package_id]

set title "Confirm Action: $action"
set context [list $title]

# some logic to handle incoherent selections 
# 'archive' or 'making permanent' only after release possible 

set halt_p 0

# template items for display

db_foreach press_items "
select   item_id,
         package_id,
         publication_name,
         publication_link,
         publication_date,
         publication_date_desc,
         template_id,
         template_adp,
         article_title,
         article_abstract,
         article_link,
         article_pages,
         html_p,
         release_date,
         archive_date,
         template_adp   
from     press_items_approved
where    item_id in ([join $pr_items ,])
and      package_id = :package_id
order by publication_date desc" {
    
    

    press_item_format

    lappend templated_list "<p> $template_value </p>"
}

set hidden_vars [export_form_vars action pr_items item_id]

ad_return_template
