<!-- /packages/press/www/admin/index.adp
     Display all press releases for administration

     @author Stefan Deusch (stefan@arsidigta.com)
     @creation-date November 21, 2000
     @cvs-id $Id$
-->

<master>
<property name="context">@context@</property>
<p>
<property name="title">@title@</property>

<p>Options:</p>

<ul>
  <li><a href="item-create">Create a new press item</a>
  <li><a href="/permissions/one?object_id=@package_id@">Set permissions</a>
  <li><a href="/admin/site-map/parameter-set?package_id=@package_id@">Set parameters</a>
  <li><a href="template-admin">Administer templates</a>
</ul>

<p>

<if @press_items:rowcount@ eq 0>
 <i>There are no press items available.</i><p>
</if>
<else>
 <table border=0>
   <tr><td>
      <form method=post action=process>
      <table width=100% border=0 cellspacing=5 cellpadding=5>
        <tr>
          <th>@column_names.0@</th>
          <th>@column_names.1@</th>
          <th>@column_names.2@</th>
          <th>@column_names.3@</th>
          <th>@column_names.4@</th>
          <th>@column_names.5@</th>
        </tr>
      <multiple name=press_items>
      <if @press_items.rownum@ odd>
        <tr>
      </if>
      <else>
        <tr bgcolor=#cccccc>
      </else>
          <td align=center bgcolor=white><input type=checkbox name=pr_items  value=@press_items.item_id@></td>
          <td align=left><a href=one-item-admin?item_id=@press_items.item_id@>@press_items.item_id@</a></td>
          <td align=left>@press_items.release_date@</td>
          <td>@press_items.publication_name@ </td>
          <td>@press_items.article_title@</td>
          <td>@press_items.status@</td>
        </tr>
      </multiple>
    </table>
  </td></tr>
  <tr><td>
    Do the following to the selected items:
    <select name=action>
      <option value="archive now" selected>Archive Now
      <option value="archive next week">Archive as of Next Week
      <option value="archive next month">Archive as of Next Month
      <option value="make permanent">Make Permanent
      <option value=delete>Delete
    </select>
    <input type=submit value=Go>
    </form>
  </td></tr> 
</table>
</else>



