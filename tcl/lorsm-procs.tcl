# packages/lorsm/tcl/lorsm-procs.tcl

ad_library {
    
    LORS Management Procedures
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-16
    @arch-tag daf81eac-5543-4f92-b06a-547313205683
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

namespace eval lorsm {

    ad_proc -public fix_url {
	-url:required
    } {
	Function use to fix URLs for course that use whitespaces for their directories,
	since the file-storage renames the directories and put a _ instead of a whitespace.
	This function should be gone when the file-storage can add folders with whitespaces.
	
	@param url The identifier reference that we need to modify.
	@author Ernie Ghiglione (ErnieG@mm.st)
	
    } {
	set filename [file tail $url]
	
	if {!([string length $filename] == [string length $url])} {
	    
	    set path [string trimright $url $filename]
	    regsub -all { } $path {_} newpath
	    return $newpath$filename
	} else {
	    return $url
	}
    }


}
    

