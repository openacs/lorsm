# packages/lorsm/www/delivery/record-view.tcl

ad_page_contract {
    
    records a view for this ims_cp_item and redirects to its url
    
    @author Deds Castillo (deds@i-manila.com.ph)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-07-04
    @arch-tag: a7aba567-c4c1-4f1c-b5f3-ebc1ab277515
    @cvs-id $Id$
} {
    item_id:notnull
    redirect_url:notnull
} -properties {
} -validate {
} -errors {
}

set viewer_id [ad_conn user_id]

set views [views::record_view -object_id $item_id -viewer_id $viewer_id]

ad_returnredirect $redirect_url
