<?xml version="1.0"?>
<queryset>

    <fullquery name="select_folder_key">
        <querytext>
            select key
            from fs_folders
            where folder_id = :folder_id
        </querytext>
    </fullquery>

    <fullquery name="sql">
        <querytext>
            select file_storage__get_root_folder(:fs_package_id)
        </querytext>
    </fullquery>

</queryset>
