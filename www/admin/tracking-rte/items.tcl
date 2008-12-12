# packages/lorsm/www/delivery/toc.tcl

ad_page_contract {

    Course Delivery Table of Content

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-04-09
    @arch-tag 553390f0-450e-48db-99f0-c5dcb17978b8
    @cvs-id $Id$
} {
    man_id:integer,notnull
    user_id:integer,notnull
} -properties {
} -validate {
} -errors {
}


# In order to share courses across classes, we need to share
# file-storage objects across file-storage instances. This has been
# proven to be really tricky. But here we pass the fs_package_id for
# the current community, so we don't have to have permissions for
# other instances of file-storages of other classes.  See
# documentation for further details.

if { ! [info exists indent] } {
    set indent 1
}

set org_id 12913
set indent [expr $indent +1]

db_multirow \
    -extend { item_id items_title identifierref } \
    suborgs select_suborgs {} {
    set item_id $item_id
}

#repeat('&nbsp;', (tree_level(tree_sortkey) - :indent)* 2) as indent,
#P
