<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<h2>#lorsm.lt_You_are_about_to_add_#</h2>
<p>
    #lorsm.Confirm_q#
    <form action="add-shared-course-2">
        <input type="hidden" name="return_url" value="@return_url@">
        <input type="hidden" name="man_id" value="@man_id@">
        <input type="submit" name="submit" value="Add @course_name@ to my class">
    </form>
