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
    # location where the templates file are
    set temp_location "[acs_root_dir]/packages/lorsm/templates"

    # location where we are going to copy the files to 
    set temp_dir "[acs_root_dir]/templates"

    # check if the template directory exists
    # Otherwise create it. 
    if {![file exists $temp_dir]} {

	file mkdir $temp_dir

    }

    foreach file [glob -nocomplain [file join $temp_location lors-*]] {

	file copy -force $file $temp_dir

    }


}
