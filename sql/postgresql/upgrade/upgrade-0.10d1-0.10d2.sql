-- upgrade from 0.10d1 o 0.10d2
--

alter table lorsm_custom_pages drop constraint lors_st_end_pgs_man_id_pk;

alter table lorsm_custom_pages add constraint lcp_man_id_type_pk primary key (man_id, type);
