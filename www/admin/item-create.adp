<!-- /packages/press/www/item-create.adp 

 $Id$

 -->

<master>
<property name="context">@context@</property>
<property name="title">@title@</property>

<p>Use the following form to define your press item. Note that the
<font color=red>red fields are required</font>.   When you're done
click 'Preview' to see how the press item will look like.</p> 

<form action=preview method=post enctype=multipart/form-data>

<table border=0>
<tr>
  <th align=right><font color=red>Publication</font></th>
  <td><input type=text size=50 maxlength=100 name=publication_name></td>
  <td><i>e.g.</i> Time</td>
</tr>

<tr>
  <th align=right>Publication URL</th>
  <td><input type=text size=50 maxlength=200 name=publication_link></td>
  <td><i>e.g.</i> http://www.time.com/</td>
</tr>

<tr>
  <th align=right><font color=red>Publication Date</font></th>	
  <td colspan=2>@publication_date@</td>
</tr>

<tr>
  <th align=right>Publication Date Description</th>
  <td><input type=text size=50 maxlength=50 name=publication_date_desc></td>
  <td><i>e.g.</i> Spring Issue</td>
</tr>

<tr>
  <th align=right><font color=red>Article Title</font></th>
  <td><input type=text size=50 maxlength=400 name=article_title></td>
  <td><i>e.g.</i> Time's person of the Year</td>
</tr>

<tr>
  <th align=right>Article URL</th>
  <td><input type=text size=50 maxlength=400 name=article_link></td>
  <td><i>e.g</i> http://www.pathfinder.com/time/poy/</td>
</tr>

<tr>
  <th align=right>Article pages</th>
  <td><input type=text size=50 maxlength=40 name=article_pages></td>
  <td><i>e.g.</i> pp 50-52</td>
</tr>

<tr>
  <th align=right valign=top><font color=red>Article Abstract</font></th>
  <td colspan=2><textarea name=article_abstract cols=80 rows=10 wrap></textarea></td>
</tr>
	
<tr>
  <td> </td>
  <td colspan=2>The abstract is formatted as 
      <input type=radio name=html_p value="f" checked> Plain Text&nbsp;
      <input type=radio name=html_p value="t" > HTML
  </td>
</tr>

<tr>
   <th align=right>Template</th>
   <td colspan=2>@template_select@</td>
</tr>

<if @press_admin_p@ ne 0>
<tr>
  <th align=right><font color=red>Release Date</font></th>
  <td colspan=2>@release_date@</td>
</tr>

<tr>
  <th align=right>Archive Date</th>
  <td colspan=2>@archive_date@ <br>
    <input type=checkbox name=permanent_p value=t>
    <b>never</b> (show it permanently)</td>
</tr>
</if>

<tr> 
  <td></td>
  <td align=left>
   <input type=hidden name=action value="Press Item">
   <input type=submit value=Preview>	
  </td>
</tr>
</table>

<p>
</form>
<hr>
<include src="template-demo">
<p>


