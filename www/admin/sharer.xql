<?xml version="1.0"?>
<queryset>

    <fullquery name="do_update">
        <querytext>
            update ims_cp_manifests
                set isshared = :share
            where man_id = :man_id
        </querytext>
    </fullquery>

    <fullquery name="party_id">
        <querytext>
            select segment_id
            from rel_segments
            where rel_type = 'dotlrn_student_profile_rel'
        </querytext>
    </fullquery>

    <fullquery name="sharer_ad_form">
        <querytext>
            select
            case when isshared = 't' then 'Shared'
            else 'Not Shared'
            end as isshared

            from ims_cp_manifests
            where man_id = :man_id
        </querytext>
    </fullquery>

</queryset>
