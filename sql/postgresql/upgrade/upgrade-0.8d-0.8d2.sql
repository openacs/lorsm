-- making column larger
ALTER TABLE lorsm_cmi_core DROP CONSTRAINT lorsm_cmi_core_item_id_fk;

-- making constraint less restrictive
ALTER TABLE lorsm_cmi_core
  ADD CONSTRAINT lorsm_cmi_core_item_id_fk FOREIGN KEY (item_id)
      REFERENCES acs_objects (object_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE lorsm_cmi_student_data ALTER max_time_allowed TYPE character varying(14);
