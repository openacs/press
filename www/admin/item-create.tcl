# /packages/press/www/item-create.tcl

ad_page_contract {

    This page enables registered users and the Press Admin 
    to enter Press article releases.

    @author sarah@arsdigita.com
    @creation-date 2000-11-14
    @cvs-id $Id$

} {
} -properties {

    title:onevalue
    context:onevalue
    publication_date:onevalue
    release_date:onevalue
    archive_date:onevalue
    template_select:onevalue
    press_admin_p:onevalue
}

set package_id [ad_conn package_id]

# With press_admin privilege items are approved immediately

set press_admin_p [ad_permission_p $package_id press_admin]

set title "Create Press Item"
set context [list $title]

set template_select "<select name=template_id>"

db_foreach template_list {
    select template_id, 
           template_name 
    from   press_templates
} {
    append template_select "<option value=$template_id>$template_name</option>\n"
}
append template_select "</select>"

set active_days [ad_parameter ActiveDays "press" 7]

set proj_archival_date [db_string week {}]

set release_date     [dt_widget_datetime -default now release_date days]
set archive_date     [dt_widget_datetime -default $proj_archival_date archive_date days]
set publication_date [dt_widget_datetime -default now publication_date days]

ad_return_template








