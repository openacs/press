# /packages/press/www/process-2.tcl

ad_page_contract {

    Confirmation page on for Press Admin to apply an drastic action  to one or more
    press item(s), currently this is either 'delete','archive', or 'make permanent'
    The page is thereafter redirected to the administer page where the result can be viewed.
    
    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date November 24, 2000
    @cvs-id $Id$

} {
 
  pr_items:notnull
  action:notnull,trim

} -errors {

    pr_items:notnull "Please check the items you want to have processed."

}

set package_id [ad_conn package_id]

switch -glob $action {
    
    delete {
	press_items_delete $pr_items
    }
    
    *archive* {
	set when [lrange $action 1 end]
	press_items_archive $pr_items $when
    }
    
    *permanent* {
	press_items_make_permanent $pr_items
    }
}

ad_returnredirect ""
