# /packages/press/www/index.tcl

ad_page_contract {
    
    Index page for the press application. Displays a list of published press item. 
    
    @author Stefan Deusch (stefan@arsdigita.com)
    @author Michael Steigman (michael@steigman.net)
    @creation-date 2000-11-22
    @cvs-id $Id$
} {

    {start:integer 0}
    {view:trim "live"}

} -properties {

    title:onevalue
    context:onevalue
    
    press_admin_p:onevalue
    press_create_p:onevalue 
    press_archive_p:onevalue
    press_live_p:onevalue
    
    templated_list:onevalue

    press_navigation:onevalue
}

# Check to make sure user has read permission on this page

set package_id [ad_conn package_id]

if ![ad_permission_p $package_id press_read] {
    ad_returnredirect unauthorized
    ad_script_abort
}

# Provide administrators with a link to the local admin pages

set press_admin_p [ad_permission_p $package_id press_admin]

# Grab the press coverage viewable by this client.  We use a pager
# system to display the press items, showing no more than display_max
# items on a page with links to previous and next pages if
# appropriate. 

set context ""

# Set the appropriate select claus based on the view

if [string equal $view archive] {
    set title "Press Archives"
    set view_clause [db_map view_clause_archive]
} else {
    set title "Press"
    set view_clause [db_map view_clause_live]
}

# pagination 

set count -1
set display_max [ad_parameter DisplayMax press 10]
set active_days [ad_parameter ActiveDays press 30]

db_foreach press_items {} {
    incr count

    if { $count < $start } {
	# skip over the initial items
	continue
    }

    if { [expr $count - $start] == $display_max } {
	# set the "more items" flag and throw away the rest of the
	# cursor 
	set more_items_p 1
	break
    }

    press_item_format

    lappend templated_list "<p> $template_value </p>"
}

# Set up the optional navigation links

set press_navigation [list]

# A little macro to help set up the indexing

proc max {x y} {
    return [expr $x > $y ? $x : $y]
}

if { $start > 0 } {
    lappend press_navigation \
	    "<a href=?view=$view&start=[max 0 [expr $start-$display_max]]>prev</a>"
}

if [info exists more_items_p] {
    lappend press_navigation \
	    "<a href=?view=$view&start=[expr $start + $display_max]>next</a>"
}

set press_navigation "<p align=center>[join $press_navigation " | "]</p>"

# Finally we provide a link to the archives or normal pages if
# appropriate.

if [string equal $view archive] {
    append press_navigation "<p>Return to <a href=\"index\">current press items</a>.</p>"
} else {
    set archived_p [db_string archive_count {}]

    if $archived_p {
	append press_navigation "<p>There are additional press items
	in the <a href=?view=archive>archives</a>.</p>"
    }
}

ad_return_template

