
create or replace function inline_0 ()
returns integer as'
declare
    template_id integer;
begin

    -- Create the (default) file_storage_object content type template

    template_id := content_template__new( 
      ''lorms-default'', -- name
      '''',               -- text
      true                      -- is_live
    );

    -- Register the template for the file_storage_object content type

    perform content_type__register_template(
      ''file_storage_object'', -- content_type
      template_id,             -- template_id
      ''lorsm'',              -- use_context
      ''t''                    -- is_default
    );

    return null;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();
