# /packages/press/www/one-item-revoke.tcl
#
# 
#
# stefan@arsdigita.com, Mon Dec  4 10:10:54 2000
#
# $Id$

ad_page_contract {

    This page allows the Press Admin to revoke an approved press item
    No intermediate page is shown for One-click action

    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date  Mon Dec  2 10:10:54 2000 
    @cvs-id $Id$

} {
    revision_id:integer,notnull  
} 

set package_id [ad_conn package_id]
# commented out because of admin directory
# ad_require_permission $package_id press_admin
set approve_p "f"

db_exec_plsql press_item_revoke_release {}

set item_id [db_string revision_root {}]

# return to one-item-admin.tcl page
ad_returnredirect one-item-admin?item_id=$item_id

