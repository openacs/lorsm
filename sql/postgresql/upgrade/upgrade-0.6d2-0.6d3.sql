-- Course presentation formats

create table lorsm_course_presentation_formats (
	format_id  			integer
						constraint lorsm_cpformats_pk
						primary key,
	format_pretty_name	varchar(200),
	format_name 		varchar(100),
	folder_name			varchar(100)
);

create index lorsm_cpformats__format_id_idx on lorsm_course_presentation_formats (format_id);

comment on table lorsm_course_presentation_formats is '
This table stores the available presentation formats for the courses. Its contains the pretty name
for the format, an id, and the folder in packages/lorsm/www/ where the presentation format is stored.
Currently just tree presentation formats exists, delivery, delivery-wihout-index and delivery-bottom-bar, 
which we store on creation';
