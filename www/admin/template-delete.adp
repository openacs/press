<!-- /packages/press/www/template-delete.adp

    @author sarah@arsdigita.com
    @creation-date 12-6-2000
    @cvs-id $Id$

-->

<master src="master">
<property name="context_bar">@context_bar@</property>
<property name="title">@title@</property>


<p>Please confirm that you want to <b>permanently delete</b> the template "@template_name@":

<blockquote> @template_value@ </blockquote>

<form action=template-delete-2 method=post>
@hidden_vars@
<center>
<input type=submit value="Yes, I want to delete it!">
</center>

</form>






