<!-- /packages/press/www/process.adp

    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date November 24, 2000
    @cvs-id $Id$

-->

<master>
<property name="context">@context@</property>
<property name="title">@title@</property>


<p>
<if @halt_p@ gt 0  and  @unapproved:rowcount@ gt 0>
  <h3>Error</h3>
  The action <font color=red>@action@</font> cannot be applied to the following item(s):
  <ul> 
    <multiple name=unapproved>
     <li><b>@unapproved.publication_name@</b> - @unapproved.article_title@ - @unapproved.creation_date@
          contributed by @unapproved.item_creator@
	 [ <a href=one-item-admin?item_id=@unapproved.item_id@><b>manage</b></a> ]
    </multiple>
  </ul>
<br>
Manage the items individually for approval first.
</if>	

<else>

<p> Do you really want to perform the action <b>@action@</b> on the following press item(s)?</p> 


<blockquote>
  <list name=templated_list> @templated_list:item@ </list>
</blockquote>
	

<center>   
   <form method=post action=process-2>	
      @hidden_vars@
      <input type=submit value="Confirm">
   </form>
</center>
</else>

