# /packages/press/www/one-item-approve.tcl

ad_page_contract {

    This page allows the Administrator of Press to approve a submitted press items
    The release_date and archive_date are selected here

    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date  Mon Dec  2 10:10:54 2000
    @cvs-id $Id$

} {

    revision_id:integer,notnull
    
} -properties {

    title:onevalue
    context_bar:onevalue
    
    article_title:onevalue
    publication_name:onevalue
    item_creator:onevalue
    item_creation_ip:onevalue
    item_creation_date:onevalue    
  
    release_date:onevalue
    archive_date:onevalue
    hidden_vars:onevalue
    press_item:onevalue
}

set package_id [ad_conn package_id]

# generate and preset Date&Time widgets

set days_until_archival [ad_parameter ActiveDays "press" 7]
set proj_archival_date  [db_string week "select sysdate + $days_until_archival from dual"]

set release_date [dt_widget_datetime -default now release_date days]
set archive_date [dt_widget_datetime -default $proj_archival_date archive_date days]


db_1row press_item_info {
    select creation_ip   as item_creation_ip,
           creation_date as item_creation_date,
           publication_name,
           publication_link,
           publication_date as pretty_publication_date,
           publication_date_desc,
           template_id,
           template_adp,
           article_title,
           article_abstract,
           article_link,
           article_pages,
           html_p,
           item_creator
    from   press_item_revisions
    where  revision_id = :revision_id
}

press_item_format

set title "Approve revision #$revision_id"
set context_bar [list $title]

# Form vars for approve step

set hidden_vars [export_form_vars revision_id]

ad_return_template
