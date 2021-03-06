ad_library {

    LORS callback imlementations

    @author Enrique Catalan (quio@galileo.edu)
    @creation-date Jul 19, 2005
    @cvs-id $Id$
}


ad_proc -callback application-track::getApplicationName -impl lorsm {} {
        callback implementation
} {
    return "lorsm"
}


ad_proc -callback application-track::getGeneralInfo -impl lorsm {} {
    callback implementation
} {
    db_1row my_query {}

    return "$result"
}


ad_proc -callback application-track::getSpecificInfo -impl lorsm {} {
    callback implementation
} {

    upvar $query_name my_query
    upvar $elements_name my_elements

    set my_query {
        select u.id,i.course_name,l.start_time,l.end_time
        from lorsm_student_track l, users u, ims_cp_manifests i
        where l.course_id IN (
            select distinct l.course_id
            from lorsm_student_track l
            where l.community_id=:class_instance_id
                group by l.course_id)
            and l.user_id = u.user_id
            and l.course_id = i.man_id
    }
    set my_elements ""

    return "OK"
}


ad_proc -public -callback imsld::import -impl lors {} {
    this is the imsld lors importer
} {
    if {$res_type == "imscp_xmlv1p0"} {
        return [lorsm::register_xml_object_id \
                    -xml_file $tmp_dir/$res_href \
                    -tmp_dir $tmp_dir \
                    -community_id $community_id]
    }
}

ad_proc -public -callback lorsm::permissions_kludge {
    -community_id
    -parent_id
    -items_parent_id
    -man_id
} {
    @author Don Baccus

    Allows a package using lorsm to kludge permissions to whatever warped view of the
    world it supports.  The first implementation provided is for dotlrn, need more be
    said?
} -

