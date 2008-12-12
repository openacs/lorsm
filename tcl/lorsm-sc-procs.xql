<?xml version="1.0"?>
<queryset>

    <fullquery name="lorsm::url.package_id">
        <querytext>
            select context_id
            from acs_objects
            where object_id = (select context_id
                                from acs_objects
                                where object_id=:man_id)
        </querytext>
    </fullquery>

</queryset>
