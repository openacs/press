# /packages/press/www/preview.tcl

ad_page_contract {

    This page shows the input from item-create.tcl or one-item-revision-add for confirmation purposes
    
    @author sarah@arsdigita.com
    @author stefan@arsdigita.com
    @creation-date 2000-12-10
    @cvs-id $Id$

} { 
    {item_id:integer ""}
    action:notnull,trim
    publication_name:notnull,trim
    {publication_link:trim ""}
    publication_date.year:notnull
    publication_date.month:notnull
    publication_date.day:notnull
    {publication_date_desc: ""}
    article_title:notnull,trim
    {article_link:trim ""}
    {article_pages: ""}
    article_abstract:notnull,allhtml,trim
    html_p:notnull,trim
    template_id:notnull
    {release_date.year: ""}
    {release_date.month: ""}
    {release_date.day: ""}
    {archive_date.year: ""}
    {archive_date.month: ""}
    {archive_date.day: ""}
    {permanent_p: "f"}

} -errors {
    publication_name:notnull "Please supply the name of the publication."
    article_title:notnull    "Please supply the title of the article."
    article_abstract:notnull "Please supply an abstract to the article."

} -validate {
    content_html -requires {article_abstract html_p} {
        if [string eq $html_p "t"] {
            set complaint [ad_check_for_naughty_html $article_abstract]
            if ![empty_string_p $complaint] {
                ad_complain $complaint
            }
        }
    }
} -properties {

    title:onevalue
    context_bar:onevalue
    template_value:onevalue
    hidden_vars:onevalue
    form_action:onevalue
}

if {[string match $action "Revision"] && [string match $item_id ""]} {
    ad_complain "I must get an item_id to create a revision. This is
    probably due to a coding error. Please complain to your system
    administrator."  
}

set package_id    [ad_conn package_id]
set press_admin_p [ad_permission_p $package_id press_admin]

set title "Preview $action"
set context_bar [list $title]

# Deal with the dates

set publication_date "${publication_date.year}-${publication_date.month}-${publication_date.day}"

# With press_admin privilege also fill in release and archive dates,
# otherwise set them to null.

if { $press_admin_p == 1 } {

    set release_date "${release_date.year}-${release_date.month}-${release_date.day}"
    set archive_date "${archive_date.year}-${archive_date.month}-${archive_date.day}"

    if { [dt_interval_check $release_date $archive_date] < 0 } {
	ad_return_error "Scheduling Error" "The archive date must be AFTER the release date."
	return
    }                                                
} else {
    set release_date ""
    set archive_date ""
}

# Variables to export

set hidden_vars [export_form_vars publication_name publication_link \
	publication_date publication_date_desc \
	article_title article_link article_abstract \
	article_pages release_date archive_date html_p \
	permanent_p template_id item_id]

if { [string match $action "Press Item"] } {
    set form_action "item-create-3"
} else {
    set form_action "one-item-revision-add-3"
}

# Grab the template code so we can create the preview

set template_adp [db_string template_adp \
	"select template_adp from press_templates where template_id = :template_id"]

press_item_format

ad_return_template