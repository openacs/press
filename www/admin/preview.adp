<!-- /packages/press/www/preview.adp

	@author sarah@arsdigita.com
	@creation-date 2000-12-10
	@cvs-id $Id$

-->

<master>
<property name="context">@context;noquote@</property>
<property name="title">@title;noquote@</property>

<p> Please confirm that you want to create the following press
item:</p>

<blockquote> @template_value;noquote@ </blockquote>

<p>

<form method=post action=@form_action;noquote@>
@hidden_vars;noquote@
<center>
<input type=submit value=Confirm>
</center>
</form>

