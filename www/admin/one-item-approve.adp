<!-- /packages/press/www/one-item-approve.adp 
 $Id:  -->

<master src="master">
<property name="context">@context@</property>
<property name="title">@title@</property>

<p>Select the release and archive dates for this press item:

<form action=one-item-approve-2 method=post enctype=multipart/form-data>

@hidden_vars@

<table>
<tr>
  <th align=right>Release Date</th>
  <td colspan=2>@release_date@</td>
</tr>

<tr>
  <th align=right>Archive Date</th>
  <td colspan=2>@archive_date@ <br>
    <input type=checkbox name=permanent_p value=t>
    <b>never</b> (show it permanently)</td>
</tr>

<tr>
  <td></td>
  <td><input type=submit value=Submit></td>
</tr>

</table>

</form>

<p>Additional information about this press item:</p>

<ul>
<li>Submitted by <font color=red>@item_creator@</font>
<li>Creation date: <font color=red>@item_creation_date@</font>
<li>Creation IP: @item_creation_ip@
<li>Displayed information: <blockquote> @template_value@ </blockquote>

</ul>

