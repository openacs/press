<!-- /packages/press/www/one-item-revision-add.adp 

    @author stefan@arsdigita.com
    @creation-date 12-1-2000
    @cvs-id $Id$

-->

<master>
<property name="context">@context;noquote@</property>
<property name="title">@title;noquote@</property>


<p>Use the following form to add a revision to this press item.
The available fields from the current active revision are 
already filled in.  Note that the <font color=red>red fields are required</font>. 
When you're done click 'Preview' to see how the press item will look.</p>

<form action=preview method=post enctype=multipart/form-data>
@hidden_vars@
<table border=0>
  <tr>
    <th align=right><font color=red>Publication</font></th>
    <td><input type=text size=50 maxlength=100 name=publication_name value="@publication_name@"></td>
  </tr>

  <tr>
    <th align=right>Publication URL</th>
    <td><input type=text size=50 maxlength=200 name=publication_link value="@publication_link@"></td>
  </tr>

  <tr>
    <th align=right><font color=red>Publication Date</font></th>	
    <td>@publication_date@</td>
  </tr>

  <tr>
    <th align=right>Publication Date Description</th>
    <td><input type=text size=50 maxlength=50 name=publication_date_desc value="@publication_date_desc@"></td>
  </tr>

  <tr>
    <th align=right><font color=red>Article Title</font></th>
    <td><input type=text size=50 maxlength=400 name=article_title value="@article_title@"></td>
  </tr>

  <tr>
    <th align=right>Article URL</th>
    <td><input type=text size=50 maxlength=400 name=article_link value="@article_link@"></td> 
  </tr>

  <tr>
    <th align=right>Article pages</th>
    <td><input type=text size=50 maxlength=40 name=article_pages value="@article_pages@"></td>
  </tr>

  <tr>
    <th align=right valign=top><font color=red>Article Abstract</font></th>
    <td><textarea name=article_abstract cols=80 rows=10 wrap>@article_abstract@</textarea></td>
  </tr>
	
  <tr>
    <td> </td>
    <td>The abstract is formatted as 
      <if @article_abstract_html_p@ not nil and @article_abstract_html_p@ ne "f"> 
        <input type=radio name=html_p value="f"> Plain Text&nbsp;
        <input type=radio name=html_p value="t" checked> HTML
      </if>
      <else>
        <input type=radio name=html_p value="f" checked> Plain Text&nbsp;
        <input type=radio name=html_p value="t"> HTML
      </else>
    </td>
  </tr>

  <tr>
    <th align=right>Template</th>
    <td colspan=2>@template_select@</td>
  </tr>

  <if @press_administrator_p@ ne 0>

  <tr>
    <th align=right><font color=red>Release Date</font></th>
    <td>@release_date@</td>
  </tr>

  <tr>
    <th align=right>Archive Date</th>
    <td>@archive_date@ <br>
        @never_checkbox@
      <b>never</b> (show it permanently)</td>
  </tr>
  </if>

  <tr>
  <th></th>
  <td align=left>
   <input type=submit value=Preview>
  </td>
  </tr>
</table>

<p>
</form>

<hr>
<include src="template-demo">
<p>