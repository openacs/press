<!-- /packages/press/www/template-ae-2.adp 
	@author Sarah Barwig (sarah@arsdigita.com)
	@creation-date 2000-12-19
	@cvs-id $Id$
-->

<master src="master">
<property name=context_bar>@context_bar@</property>
<property name=title>@title@</property>

<p>The following preview shows what items formatted using the template
<b>@template_name@</b> will look like:</p>

<blockquote> @template_value@ </blockquote>

<form action=template-ae-3 method=post enctype=multipart/form-data>
@hidden_vars@
<p>
<center>
<input type=submit value="Save Template">
</center>

</form>








