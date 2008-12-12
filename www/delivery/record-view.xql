<?xml version="1.0"?>
<queryset>

    <fullquery name="getitemattributes">
        <querytext>
            select i.parent_item, i.ims_item_id, i.item_title as item_title,
                i.prerequisites_s as prerequisites, cr.mime_type
            from acs_objects o, ims_cp_items i, cr_items ci, cr_revisions cr,
                ims_cp_manifest_class im, ims_cp_organizations org
            where o.object_type = 'ims_item_object'
                and i.org_id = org.org_id
                and o.object_id = i.ims_item_id
                and im.man_id=:man_id
                and i.ims_item_id=:revision_id
                and im.isenabled='t'
                and im.community_id=:community_id
                and ci.item_id=cr.item_id
                and cr.revision_id=i.ims_item_id
        </querytext>
    </fullquery>

    <fullquery name="givemeid">
        <querytext>
            select i.ims_item_id as id_from_ref, i.item_title as id_from_ref_title
            from ims_cp_items i, ims_cp_manifest_class im, ims_cp_organizations o
            where i.identifier=:prer
                and o.org_id = i.org_id
                and o.man_id = :man_id
                and im.man_id= :man_id
                and im.isenabled='t'
                and im.community_id=:community_id
        </querytext>
    </fullquery>

    <fullquery name="isanysuspendedsession">
        <querytext>
            select lorsm.track_id as track_id, cmi.lesson_status as lex_status
            from lorsm_student_track lorsm, lorsm_cmi_core cmi
            where lorsm.user_id = $user_id
                and lorsm.community_id = $community_id
                and lorsm.course_id = $man_id
                and lorsm.track_id = cmi.track_id
                and cmi.man_id = $man_id
                and cmi.item_id = $id_from_ref
            order by lorsm.track_id desc
        </querytext>
    </fullquery>

</queryset>
