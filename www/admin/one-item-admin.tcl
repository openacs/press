# /packages/press/www/admin/one-item-admin.tcl

ad_page_contract {

    This one-item page is the UI for the Press Administrator
    You can view one press item with all its 
    revisions. A new revision can be added.
   
    @author stefan@arsdigita.com
    @creation-date Wed Nov 29 15:44:15 2000
    @cvs-id $Id$

} {

    item_id:integer,notnull

} -properties {

    title:onevalue
    context:onevalue
    hidden_vars:onevalue
    item_id:onevalue
    item_revisions:multirow
    
}

set package_id [ad_conn package_id]

set title "One item"
set context [list $title]

# Form vars for the 'Update' button

set hidden_vars [export_form_vars item_id]

# Get all revisions of this press item.  Note the use of "null as
# template_value" in the select.  This defines the variable
# template_value as part of the ns_set for export to the adp page,
# although the actual value is defined by the call to
# press_item_format. 

db_multirow item_revisions item_revs_list {
    select item_id,
           revision_id,
           publication_name,
           publication_link,
           publication_date,
           publication_date_desc,
           article_title,
           article_link,
           article_pages,
           article_abstract,
           html_p,
           creation_date,
           status,
           item_creator,
           creation_ip,
           decode(status,'unapproved',0,1) as approved_p,
           template_id,
           template_adp,
           null as template_value,
           decode(content_revision.is_live(revision_id),'t',1,0) as is_live_p
    from   press_item_revisions
    where  item_id    = :item_id
    and    package_id = :package_id 
    order  by revision_id desc
} {
    # Now call the formatting procedure to fill in the correct value
    # for "template_value".

    press_item_format
}

ad_return_template

