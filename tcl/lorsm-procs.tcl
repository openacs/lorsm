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

    ad_proc -public fix_href {
	-item_title:required
	-identifierref:required
	-fs_package_id:required
	-folder_id:required
    } {
	Function use to fix the HREF of resources.
	It could be that the reference to a resource is outside the 
	scope of the learning object (somewhere on the web) instead
	of a file or resource in the course. 

	Therefore, this function determines whether ther link to the
	resource is within the course materials. If that is the case
	it created the link to where the file is stored in the file-
	storage. Otherwise, if the resource needs to be fetched from
	the web (http://) then we use that href instead.
	
	@param item_title The title of the item in question
	@param identifierref The resource's identifierref 
	@param fs_package_id the file-storage package id
	@param folder_id file-storage folder id
	@author Ernie Ghiglione (ErnieG@mm.st)
	
    } {

	if {![empty_string_p $identifierref]} {
	    
	    if {[regexp "http://" $identifierref]} {
		
		return "<a href=\"$identifierref\" target=\"body\">$item_title</a>"

	    } else {

		set url1 "[apm_package_url_from_id $fs_package_id]view/"
		set url2 "[db_string select_folder_key {select key from fs_folders where folder_id = :folder_id}]/"
		set url3 [lorsm::fix_url -url $identifierref]

		set url "<a href=\"$url1$url2/$url3\" target=\"body\">$item_title</a>"

		return $url
	    }
	
	} else {
	    return $item_title
	}

    }
}
    

