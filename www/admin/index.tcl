# /packages/press/www/administer.tcl

ad_page_contract {


    Display a list of press items releases for administration

    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date November 24, 2000
    

} {
  {orderby: "item_id"}
  {desc_p: "desc"}
  {column_names:array ""}
} -properties {

    title:onevalue
    context:onevalue
    press_items:multirow
    package_id:onevalue
}

set package_id [ad_conn package_id]

set title "Press Administration"
set context ""

# set column_names in array

set column_names(0) "Select"
set column_names(1) "ID#"
set column_names(2) "Release Date"
set column_names(3) "Publication"
set column_names(4) "Article"
set column_names(5) "Status"

# administrator sees all press items

db_multirow press_items itemlist "
select item_id,
       press_id,
       publication_name,
       article_title,
       release_date,
       status
from   press_items
where  package_id = :package_id 
order  by :orderby desc"

ad_return_template








