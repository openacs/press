# /packages/press/www/template-delete-2.tcl

ad_page_contract {

    @author sarah@arsdigita.com
    @creation-date 2000-12-6
    @cvs-id $Id$

} {
    
    template_id:notnull,integer

}

set package_id [ad_conn package_id]
# commented out because of admin directory
# ad_require_permission $package_id press_admin

# update cr_press set all with template_id to null? or default template_id
# delete template


db_dml reset_press_templates "
    update cr_press
    set template_id = (select template_id from press_templates where template_name='Default')
    where template_id = :template_id"

db_dml delete_template "
    delete from press_templates
    where template_id = :template_id"

ad_returnredirect template-admin
