<!-- /packages/press/www/template-ae-2.adp 
	@author Sarah Barwig (sarah@arsdigita.com)
	@creation-date 2000-12-19
	@cvs-id $Id$
-->

<master>
<property name="context">@context;noquote@</property>
<property name=title>@title;noquote@</property>

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








