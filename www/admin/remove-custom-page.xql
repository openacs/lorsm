<?xml version="1.0"?>
<queryset>

    <fullquery name="remove_page">
        <querytext>
            delete
            from lorsm_custom_pages
            where man_id=:man_id
                and type=:type
        </querytext>
    </fullquery>

</queryset>
