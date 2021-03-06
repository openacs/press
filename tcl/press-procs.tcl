# /packages/press/tcl/press-procs.tcl

ad_library {
    Utility functions for Press Application

    @author stefan@arsdigita.com
    @author sarah@arsdigita.com
    @author michael@steigman.net
    @creation-date 2000-12-1
    @cvs-id $Id$

}

ad_proc press_items_archive { id_list when } { 
    immediately gives all press items in list id_list
    a status of archived as described in when
} {
    set package_id [ad_conn package_id]
    ad_require_permission $package_id press_admin    

    # parse the when info

    switch [join $when] { 
	"now" {
	    set archive_date [db_string now {}]
	}
	"next week" {
	    set archive_date [db_string next_week {}]
	}
	"next month" { 
	    set archive_date [db_string next_month {}]
	}
    }
    
    foreach id $id_list {
	db_exec_plsql press_item_archive {}
    }   
}

ad_proc press_items_make_permanent { id_list } {    
    immediately gives all press items in list id_list
    a status of permanently published
} {
    
    set package_id [ad_conn package_id]
    ad_require_permission $package_id press_admin
    foreach id $id_list {
	db_exec_plsql press_item_make_permanent {}
    }
}


ad_proc press_items_delete { id_list } {
    deletes all press items with press_id in id_list
} { 
    set package_id [ad_conn package_id]
    ad_require_permission $package_id press_delete
    foreach id $id_list {
	db_exec_plsql press_item_delete {}
    }
}

ad_proc press_item_sample {} {
    Sets sample press coverage variables (publication_name,
    publication_date, etc.) in the stack frame of the caller.
} {    
    uplevel 1 { 
	set publication_name "Time"
	set publication_link "http://www.time.com/"
	set publication_date "January 1, 2001"
	set publication_date_desc "Fall Issue"
	set article_title     "Time's Person of the Year"
	set article_link      "http://www.pathfinder.com/time/poy/"
	set article_pages     "pp 50-52"
	set article_abstract  "Welcome, Jeff Bezos, to TIME's Person
	of the Year club. As befits a new-era entrepreneur, at 35 you
	are the fourth youngest individual ever, preceded by
	25-year-old Charles Lindbergh in 1927; Queen Elizabeth II, who
	made the list in 1952 at age 26; and Martin Luther King Jr.,
	who was 34 when he was selected in 1963. A pioneer, royalty
	and a revolutionary--noble company for the man who is,
	unquestionably, king of cybercommerce."
	set html_p "f"
    }
}

ad_proc press_item_format {} {
    Sets the variable "template_value" in the stack frame of the
    caller.  Due to upleveling which occurs in template::adp_eval,
    this needs to execute in the calling level, as opposed to having
    variables passed in and returning an HTML string. *sigh*. 

    This proc requires all variables used in the template be set in the
    calling level. 

    Specifically: publication_name, publication_link, article_name,
    article_link, publication_date, article_pages, article_abstract,
    html_p.
} {
    uplevel 1 {

	set template_vars {
	    publication_name 
	    publication_link 
	    article_title
	    article_link 
	    publication_date 
	    publication_date_desc 
	    article_pages 
	    article_abstract 
	    html_p 
	}
	
	# Make a backup copy of the local values for our processing

	foreach var $template_vars {
	    set _$var [set $var]
	}

	# Insert optional hyperlinks (clickthrough tracking optional)
	set clickthrough_p [ad_parameter ClickThroughP press 0]
	
	if ![empty_string_p $publication_link] {
	    if {$clickthrough_p != 0} {
		set publication_name \
			"<a href=/ct/press/?send_to=$publication_link>$publication_name</a>"
	    } else {
		set publication_name "<a href=$publication_link>$publication_name</a>"
	    }
	}
	
	if ![empty_string_p $article_link] {
	    if {$clickthrough_p != 0} {
		set article_title "<a href=/ct/press/?send_to=$article_link>$article_title</a>"
	    } else {
		set article_title "<a href=$article_link>$article_title</a>"
	    }
	}
	
	if [exists_and_not_null publication_date_desc] {
	    set publication_date $publication_date_desc
	} else {
	    set publication_date [dt_ansi_to_pretty $publication_date]
	}

	if { $html_p == "f" } {
	    set article_abstract [ns_quotehtml $article_abstract]
	} 

	# Compile and evalute the template

	while {[regsub -all [template::adp_variable_regexp] $template_adp {\1@\2;noquote@} template_adp]} {}	
	set template_code  [template::adp_compile -string $template_adp]
	set template_value [template::adp_eval template_code]

	# Restore the original values of the template variables

	foreach var $template_vars {
	    set $var [set _$var]
	}
    }
}

ad_proc press_template_select { 
    {template_default "1"}
} {

    Returns an HTML select widget for choosing a press template

} {
    set template_select "<select name=template_id>"

    db_foreach template_list {} {
	if {[string equal $tid $template_default]} {
	    append template_select "<option value=$tid selected>$tname</option>\n"
	} else {
	    append template_select "<option value=$tid>$tname</option>\n"
	}
    }

    return [concat $template_select "\n</select>\n"]
}


