<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_cp_manifest_class
            set istrackable = :enable
            where man_id = :man_id
                and lorsm_instance_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="tracker_ad_form">
        <querytext>
            select
            case when istrackable = 't' then 'Yes'
            else 'No'
            end as istrackable

            from ims_cp_manifest_class
            where man_id = :man_id
                and lorsm_instance_id = :package_id
        </querytext>
    </fullquery>

</queryset>
