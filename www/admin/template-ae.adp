<!-- /packages/press/www/template-ae.adp

    @author sarah@arsdigita.com
    @creation-date 2000-12-19
    @cvs-id $Id$

-->

<master>
<property name="context">@context;noquote@</property>
<property name="title">@title;noquote@</property>


<form action=template-ae-2 method=post enctype=multipart/form-data>
<table border=0>
  <tr>
    <th align=right>Template Name</th>
    <if @template_id@ eq 1>
       <td>Default</td>
       <input type=hidden name=template_name value="Default">
    </if>
    <else>
       <td><input type=text size=40 maxlength=100 name=template_name value="@template_name@"></td>
    </else>
  </tr>

  <tr>
    <th align=right valign=top>Template Body</th>
    <td><textarea name=template_adp cols=60 rows=10 wrap=soft>@template_adp@</textarea>
    </td>

  </tr>

  <tr>
  <td></td>
  <td><input type=submit value=Preview></td>
  </tr>

</table>

<p>

@hidden_vars@

</form>

<h3>Instructions</h3>

<p>Enter an HTML fragment to specify a press coverage template.  You can
refer to the following variables:

<dl compact>
<dt><code>&#064;publication_name&#064;</code>
<dd>Name of the publication
<dt><code>&#064;publication_date&#064;</code>
<dd>When the article was published (date or description)
<dt><code>&#064;article_title&#064;</code>
<dd>Name of the article
<dt><code>&#064;article_pages&#064;</code>
<dd>Page reference for the article
<dt><code>&#064;article_abstract&#064;</code>
<dd>Abstract or summary of the article
</dl>






