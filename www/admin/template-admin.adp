<!-- /packages/press/www/template-admin.adp

     UI for press_admin to define/edit/delete templates 

     @author Stefan Deusch (stefan@arsdigita.com)
     @creation-date December 8, 2000
     @cvs-id $Id$
-->

<master>
<property name="context">@context;noquote@</property>
<p>
<property name="title">@title;noquote@</property>

<ul>
<list name=template_list> @template_list:item;noquote@ </list>
</ul>

<p>

<ul> <li><a href=template-ae?action=create>Add a new template</a></li> </ul>
