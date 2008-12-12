<?xml version="1.0"?>
<queryset>

    <fullquery name="select_formats_for_select_widget">
        <querytext>
            select format_pretty_name, format_id
            from lorsm_course_presentation_formats
            order by format_pretty_name
        </querytext>
    </fullquery>

    <fullquery name="get_data">
        <querytext>
            select cp.course_presentation_format as format, pf.format_pretty_name
            from ims_cp_manifests cp, lorsm_course_presentation_formats pf
            where cp.man_id = :man_id
                and cp.course_presentation_format = pf.format_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_cp_manifests
                set course_presentation_format = :format
            where man_id = :man_id
        </querytext>
    </fullquery>

</queryset>
