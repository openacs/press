<!-- /packages/press/www/one-item-admin.adp 

$Id$

-->

<master>
<property name="context">@context;noquote@</property>
<property name="title">@title;noquote@</property>

<p>Options:</p>

<ul>
<li><a href=one-item-revision-add?item_id=@item_id@>Add a new revision</a>
</ul>

<form method=post action=one-item-revision-update> 

@hidden_vars@

<table width=100% border=0>
    <tr>
    <th>Revision #</th>
    <th>Active Revision</th>
    <th>Creation Date</th>
    <th>Author</th>
    <th>Creation IP</th>
    <th>Status</th>
    </tr>	

    <multiple name=item_revisions>

    <if @item_revisions.rownum@ odd>
    <tr>
    </if>
    <else>
    <tr bgcolor=#cccccc>
    </else>
    <td align=center rowspan=2>
    <%= [expr @item_revisions:rowcount@ - @item_revisions.rownum@ + 1]%>
    </td>

    <td align=center rowspan=2>
    <if @item_revisions.is_live_p@ eq 1>
    <input type=radio name=revision_id value=@item_revisions.revision_id@ checked>
    </if>
    <else>
    <input type=radio name=revision_id value=@item_revisions.revision_id@>
    </else>
    </td>

    <td align=center>@item_revisions.creation_date@</td>
    <td align=center>@item_revisions.item_creator@</td>
    <td align=center>@item_revisions.creation_ip@</td>
    <td align=center>@item_revisions.status@

    <if @item_revisions.approved_p@ eq 0>
              | <a href=one-item-approve?revision_id=@item_revisions.revision_id@>approve</a>
    </if>
    <else>
              | <a href=one-item-revoke?revision_id=@item_revisions.revision_id@>revoke</a>
    </else>
    </td>
    </tr>

    <if @item_revisions.rownum@ odd>
    <tr>
    </if>
    <else>
    <tr bgcolor=#cccccc>
    </else>
       <td align=left colspan=4>	
	 <table>
	    @item_revisions.template_value@
	 </table>
        </td>
    </tr>
    </multiple>

   <if @item_revisions.rownum@ ne "1">
   <tr>
    <td></td>
    <td align=center><input type=submit value="Update"></td>
   </tr>
   </if>

</table>


</form>






