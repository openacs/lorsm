<?xml version="1.0"?>
<queryset>

    <fullquery name="lorsm::install::package_install.create_default_format">
        <querytext>
            insert into lorsm_course_presentation_formats
            values
                (-1,:pretty_name,'default','delivery')
        </querytext>
    </fullquery>

    <fullquery name="lorsm::install::package_install.create_no_index_format">
        <querytext>
            insert into lorsm_course_presentation_formats
            values
                (-2,:pretty_name,'without_index','delivery-no-index')
        </querytext>
    </fullquery>

    <fullquery name="lorsm::install::package_install.create_no_index_format2">
        <querytext>
            insert into lorsm_course_presentation_formats
            values
                (-3,:pretty_name,'bottom_navigation_bar','delivery-bottom-bar')
        </querytext>
    </fullquery>

    <fullquery name="lorsm::install::package_install.create_no_index_format3">
        <querytext>
            insert into lorsm_course_presentation_formats
            values
                (-4,:pretty_name,'progress-bar','delivery-progress-bar')
        </querytext>
    </fullquery>

    <fullquery name="lorsm::install::after_upgrade.create_no_index_format">
        <querytext>
            insert into lorsm_course_presentation_formats
            values
                (-4,:pretty_name,'progress-bar','delivery-progress-bar')
        </querytext>
    </fullquery>

</queryset>
