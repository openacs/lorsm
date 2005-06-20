
create or replace function inline_0 ()
returns integer as'
declare
    template_id integer;
begin

    -- Remove the (default) file_storage_object content type template

    template_id := content_test__get_val(''lorms-default'');

    -- Unregister the template for the file_storage_object content type

    perform content_type__unregister_template(
      ''file_storage_object'', -- content_type
      template_id,             -- template_id
      ''lorsm''              	-- use_context
    );

    return null;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();
