<?xml version="1.0"?>
<queryset>

    <fullquery name="select_size">
        <querytext>
            select ims_md_id
            from ims_md_educational
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_update">
        <querytext>
            update ims_md_educational
            set sem_density_s = :sem_density_s,
                sem_density_v = :sem_density_v
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

    <fullquery name="do_insert">
        <querytext>
            insert into ims_md_educational
                (ims_md_id, sem_density_s, sem_density_v)
            values
                (:ims_md_id, :sem_density_s, :sem_density_v)
        </querytext>
    </fullquery>

    <fullquery name="select_ed_semd">
        <querytext>
            select '(' || sem_density_s || ') ' || sem_density_v as semd, ims_md_id
            from ims_md_educational
            where ims_md_id = :ims_md_id
        </querytext>
    </fullquery>

</queryset>
