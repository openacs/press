# /packages/press/www/one-item-approve-2.tcl

ad_page_contract {

    This page inserts the release_date and archive_date (if applicable)
    into cr_press(press_id) without intermediate confirmation
    After the insert the administrator is redirected to the one-item-admin page
    to see the result.

    @author stefan@arsdigita.com
    @creation-date 2000-12-04
    @cvs-id $Id$

} { 
    revision_id
    {permanent_p: "f"}
    release_date.year:notnull
    release_date.month:notnull
    release_date.day:notnull
    archive_date.year:notnull
    archive_date.month:notnull
    archive_date.day:notnull
}

set package_id [ad_conn package_id]

# Date processing

set release_date "${release_date.year}-${release_date.month}-${release_date.day}"
set archive_date "${archive_date.year}-${archive_date.month}-${archive_date.day}"

if { [dt_interval_check $release_date $archive_date] < 0 } {
    ad_return_error "Scheduling Error" "The archive date must be AFTER the release date."
    ad_script_abort
}                                                

set item_id [db_string revision_root \
	"select item_id from cr_revisions where revision_id = :revision_id"]

db_exec_plsql press_item_approve_release {
    begin
    press.approve_release(:revision_id,:release_date,:archive_date);
    end;
}	

ad_returnredirect "one-item-admin?item_id=$item_id"



