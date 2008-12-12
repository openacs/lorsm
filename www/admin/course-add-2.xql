<?xml version="1.0"?>
<queryset>

    <fullquery name="select_formats_for_select_widget">
        <querytext>
            select format_pretty_name, format_id
            from lorsm_course_presentation_formats
            order by format_pretty_name
        </querytext>
    </fullquery>

    <fullquery name="default_format">
        <querytext>
            select format_id
            from lorsm_course_presentation_formats
            where format_name = 'default'
        </querytext>
    </fullquery>

</queryset>
