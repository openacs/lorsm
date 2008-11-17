# packages/lorsm/tcl/lorsm-install-procs.tcl

ad_library {

    LORSM Installation procedures

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-08-19
    @arch-tag: 535eebaf-8414-4703-8a39-e115a34b68f1
    @cvs-id $Id$
}

#
#  Copyright (C) 2004 Ernie Ghiglione
#
#  This package is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  It is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#


namespace eval lorsm::install {}

ad_proc -private lorsm::install::package_install {} {

    Install the lorsm-templates

} {
    lorsm::install::templates

    # by the moment we only have tree format presentations and there is no
    # way (by the moment) to add more dinamically, so we create them with an non dynamic id

    set pretty_name "[_ lorsm.Classic_Style]"
    # Insert default values for the course presentation formats
    db_dml create_default_format {
        insert into lorsm_course_presentation_formats
        values (-1,:pretty_name,'default','delivery')}

    set pretty_name "[_ lorsm.lt_Without_LORSM_Index_S]"
    db_dml create_no_index_format {
        insert into lorsm_course_presentation_formats
        values (-2,:pretty_name,'without_index','delivery-no-index')}

    set pretty_name "[_ lorsm.lt_With_Bottom_Navigatio]"
    db_dml create_no_index_format {
        insert into lorsm_course_presentation_formats
        values (-3,:pretty_name,'bottom_navigation_bar','delivery-bottom-bar')}

    set pretty_name "[_ lorsm.lt_With_Progress_Bar]"
    db_dml create_no_index_format {
        insert into lorsm_course_presentation_formats
        values (-4,:pretty_name,'progress-bar','delivery-progress-bar')}

    # Service contract implementations - fts
    lorsm::sc::register_implementations
}

ad_proc -private lorsm::install::after_upgrade {
    {-from_version_name:required}
    {-to_version_name:required}
} {

    Upgrade logic

} {
    apm_upgrade_logic \
        -from_version_name $from_version_name \
        -to_version_name $to_version_name \
        -spec {
            0.7d 0.8d {
                set pretty_name "[_ lorsm.lt_With_Progress_Bar]"
                db_dml create_no_index_format {
                    insert into lorsm_course_presentation_formats
                    values (-4,:pretty_name,'progress-bar','delivery-progress-bar')}

            } 0.8d1 0.8d2 {
                lorsm::install::templates

            } 0.8d3 0.8d4 {
                lorsm::install::templates
            }
        }
}

ad_proc -private lorsm::install::templates {
} {
    # location where the templates file are
    set temp_location "[acs_root_dir]/packages/lorsm/templates"

    # location where we are going to copy the files to
    set temp_dir "[acs_root_dir]/templates"

    # check if the template directory exists
    # Otherwise create it.
    if {![file exists $temp_dir]} {
        file mkdir $temp_dir
    }

    foreach file [glob -nocomplain [file join $temp_location lorsm-*]] {
        file copy -force $file $temp_dir
    }
}
