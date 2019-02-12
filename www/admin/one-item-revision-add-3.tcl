# /packages/press/www/one-item-revision-add-3.tcl

ad_page_contract {

    This page adds a new revision to a press item 
    and redirects to the one-item-admin page of that item

    @author stefan@arsdigita.com
    @creation-date 12-1-2000
    @cvs-id $Id$

} { 
    item_id:integer
    publication_name:notnull
    {publication_link ""}
    publication_date:notnull
    {publication_date_desc ""}
    article_title:notnull
    {article_link:trim ""}
    {article_pages:trim ""}
    article_abstract:notnull,allhtml,trim
    html_p:notnull
    release_date:notnull
    archive_date:notnull
    permanent_p:notnull
    template_id:integer,notnull
}

set package_id [ad_conn package_id]

if {$permanent_p == "t"} {
    set archive_date ""
}

# Get creation info

set creation_ip   [ad_conn "peeraddr"]
set creation_user [ad_conn "user_id"]


# this should only be used when admin is making revision 
# live at time of writing...

if { [ad_permission_p $package_id press_admin] } {
    set approval_user [ad_conn "user_id"]
    set approval_ip   [ad_conn "peeraddr"]
    set approval_date [dt_sysdate]
} else {
    set approval_user ""
    set approval_ip   ""
    set approval_date ""
}

# set mime_type

if {[string match $html_p t]} {
    set mime_type "text/html"
} else {
    set mime_type "text/plain"
}

# reserve empty clob for future

set txt ""

# make new revision the active revision

set active_revision_p "t"

# Insert

db_exec_plsql create_press_item_revision {}

ad_returnredirect "one-item-admin?item_id=$item_id"

