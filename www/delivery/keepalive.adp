<p>
    Keepalive window
    Shouldn't ever turn to login HREF
   <%= [ns_httptime [ns_time]] %>
</p>

<if @user_id@ eq 0>#acs-subsite.Not_logged_in#<br>
    <a href="@login_url@">#acs-subsite.Login_or_register#</a>
</if>
<else>
    @user_name@<br>
</else>
