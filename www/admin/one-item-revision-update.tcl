# /packages/press/www/one-item-revision-update.tcl

ad_page_contract {
    
    This page changes the active revision of a press item and returns one-item-admin

    @author stefan@arsdigita.com
    @creation-date 12-1-2000
    @cvs-id $Id$
    
} {

    item_id:integer,notnull
    revision_id:integer,notnull
}

db_exec_plsql update_forum {
    begin
    press.set_active_revision (:revision_id);
    end;
}

ad_returnredirect "one-item-admin?item_id=$item_id"
