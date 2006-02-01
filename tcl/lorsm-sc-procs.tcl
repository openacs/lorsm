ad_library {

    lorsm Library - Service Contracts

    @creation-date 2006-01-18
    @author eduardo.perez@uc3m.es
    @cvs-id $Id$
}

namespace eval lorsm {}
namespace eval lorsm::sc {}

ad_proc -private lorsm::datasource { man_id } {
    @param man_id
} {
    # noop
}

ad_proc -private lorsm::url { man_id } {
    @param man_id

    returns the url for the lorsm man

} {
	set package_id [db_string package_id {	
        select package_id from cr_folders where folder_id=(select context_id from acs_objects where object_id=:man_id)
    }]
	set url [apm_package_url_from_id $package_id]
	return "${url}delivery-no-index/?man_id=$man_id"
}

ad_proc -private lorsm::sc::register_implementations {} {
    Register the ims_manifest_object content type fts contract
} {
    lorsm::sc::register_fts_impl
}

ad_proc -private lorsm::sc::unregister_implementations {} {
    acs_sc::impl::delete -contract_name FtsContentProvider -impl_name ims_manifest_object
}

ad_proc -private lorsm::sc::register_fts_impl {} {
    set spec {
        name "ims_manifest_object"
        aliases {
            datasource lorsm::datasource
            url lorsm::url
        }
        contract_name FtsContentProvider
        owner lorsm
    }

    acs_sc::impl::new_from_spec -spec $spec
}
