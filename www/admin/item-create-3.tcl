# /packages/press/www/item-create-3.tcl

ad_page_contract {

    This page makes the final insert into the database to create a new press item
    Doubleclick protection: wait for solution on bboard

    @author sarah@arsdigita.com
    @author stefan@arsdigita.com
    @creation-date 2000-11-14
    @cvs-id $Id$
    
} {
    publication_name:notnull
    {publication_link: ""}
    publication_date:notnull
    {publication_date_desc: ""}
    article_title:notnull
    {article_link:trim ""}
    article_abstract:notnull,allhtml,trim
    {article_pages:trim ""}
    {release_date:trim  ""}
    {archive_date:trim  ""}
    html_p:notnull
    permanent_p:notnull
    template_id:integer,notnull
}  -properties {

    title:onevalue
    context:onevalue

}

set package_id [ad_conn package_id]

set title "Confirm Sumbission"
set context [list $title]

# with press_admin privileges, expect a release and archive date 

set press_admin_p [ad_permission_p $package_id press_admin]

if { $press_admin_p == 1 && $permanent_p == "t"} {
    set archive_date ""
} 

# Parent root folder where press_items live

set package_id [ad_conn package_id]
set parent_id  [db_string press_folder_id {}]

# build name for content-repository

set item_id [db_string object_id {}]

set    name "press-"
append name [db_string datestring {}]
append name "-$item_id"

# get creation info

set creation_date [dt_sysdate]
set creation_ip   [ad_conn "peeraddr"]
set creation_user [ad_conn "user_id"]

# get approval info only if the administrator 
# is creating and approving the press item in one step

if { [ad_permission_p $package_id press_admin] } {
    set approval_user [ad_conn "user_id"]
    set approval_ip   [ad_conn "peeraddr"]
    set approval_date [dt_sysdate]
    set live_revision_p "t"
} else {
    set approval_user ""
    set approval_ip   ""
    set approval_date ""
    set live_revision_p "f"
}

# set mime_type

if {[string match $html_p t]} {
    set mime_type "text/html"
} else {
    set mime_type "text/plain"
}

# reserve empty clob for future
# this will need to be filled in when the news module 
# extends this press module

set txt ""

# do insert

set press_id [db_exec_plsql create_press_item {}]

# privilege-dependent redirects

if { $press_admin_p == 0 } {
    ad_return_template item-create-thankyou
} else {
    ad_returnredirect ""

}









