# /packages/press/www/one-item-revision-add.tcl

ad_page_contract {
    
    This page serves as UI to add a new revision of a press item
    By default, the active_revision_id is filled into the widgets
    Currently only Press Admin can do this, not the original submittor though


    @author stefan@arsdigita.com
    @creation-date 12-1-2000
    @cvs-id $Id$
    
} {

    item_id:integer,notnull
    
} -properties {

    title:onevalue
    context:onevalue
    publication_name:onevalue
    publication_link:onevalue
    publication_date:onevalue
    publication_date_desc:onevalue
    article_title:onevalue
    article_link:onevalue
    article_pages:onevalue
    article_abstract:onevalue
    article_abstract_html_p:onevalue
    press_administrator_p:onevalue
    release_date:onevalue
    archive_date:onevalue
    template_select:onevalue
    never_checkbox:onevalue
    hidden_vars:onevalue

}


# Permission to press_admin 

set package_id            [ad_conn package_id]
set press_administrator_p [ad_permission_p $package_id press_admin]

set title "Add new revision"
set context [list $title]

# get active revision of press item

db_0or1row item  "
select pr.revision_id,
       publication_name,
       publication_link,
       publication_date as item_publication_date,
       publication_date_desc,
       article_title,
       article_link,
       article_pages,
       article_abstract,
       html_p as article_abstract_html_p,
       template_id,
       template_name,
       release_date as item_release_date,
       archive_date as item_archive_date,
       status
from   press_item_revisions pr
where  pr.item_id = :item_id
and    package_id = :package_id
and    content_revision.is_live(revision_id) = 't'"

set never_checkbox "<input type=checkbox name=permanent_p value=t "

if {[string equal $status "permanent"]} {
    append never_checkbox "checked"
}

append never_checkbox ">"


# make Date & Time Widgets

set release_date     [dt_widget_datetime -default $item_release_date release_date days]
set archive_date     [dt_widget_datetime -default $item_archive_date archive_date days]
set publication_date [dt_widget_datetime -default $item_publication_date publication_date days]

set template_select  [press_template_select $template_id]

set action "Revision"
set hidden_vars [export_form_vars item_id action]

ad_return_template
