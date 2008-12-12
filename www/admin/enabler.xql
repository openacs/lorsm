<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_cp_manifest_class
            set isenabled = :enable
            where man_id = :man_id
                and lorsm_instance_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="enabler_form">
        <querytext>
            select
                case when isenabled = 't' then 'Enabled'
                else 'Disabled'
                end as isenabled
            from ims_cp_manifest_class
            where man_id = :man_id
                and lorsm_instance_id = :package_id
        </querytext>
    </fullquery>

</queryset>
