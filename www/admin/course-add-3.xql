<?xml version="1.0"?>
<queryset>

    <fullquery name="party_id_member">
        <querytext>
            select segment_id
            from rel_segments
            where group_id = :community_id
                and rel_type = 'dotlrn_member_rel'
        </querytext>
    </fullquery>

    <fullquery name="party_id_admin">
        <querytext>
            select segment_id
            from rel_segments
            where group_id = :community_id
                and rel_type = 'dotlrn_admin_rel'
        </querytext>
    </fullquery>

    <fullquery name="party_id_professor">
        <querytext>
            select segment_id
            from rel_segments
            where rel_type = 'dotlrn_professor_profile_rel'
        </querytext>
    </fullquery>

    <fullquery name="party_id_admins">
        <querytext>
            select segment_id
            from rel_segments
            where rel_type = 'dotlrn_admin_profile_rel'
        </querytext>
    </fullquery>

</queryset>
