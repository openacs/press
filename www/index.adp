<!--
     Display available, live press items

     @author Stefan Deusch (stefan@arsidigta.com)
     @creation-date November 21, 2000
     @cvs-id $Id$
-->

<master src="master">
<property name="context">@context@</property>
<property name="title">@title@</property>

<if @press_admin_p@ ne 0>
  <p>
    <table width="100%">
     <tr>
      <th align=right>
       <a href="admin">Administer</a>
      </th>
     </tr>
    </table>	
</if>

<if @templated_list@ nil>
  <p><i>There are no press items available.</i></p>
</if>

<else>
 <p>
 <blockquote>
  <table width=80% border=0 cellspacing=20>
  <list name=templated_list>
        @templated_list:item@
  </list>
  </table>
 </blockquote>
</else>

@press_navigation@
