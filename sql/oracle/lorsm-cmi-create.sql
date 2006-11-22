-- packages/lorsm/sql/oracle/lorsm-cmi-create.sql
--
-- @author Giancarlo Luxardo
-- Adapted for Oracle by Mario Aguado <maguado@innova.uned.es>
-- @author Mario Aguado <maguado@innova.uned.es>
-- @creation-date 25/07/2006
-- @cvs-id $Id$
--

-- SCORM 1.2 Run-Time Environment

-- cmi.core category

create table lorsm_cmi_core (
	track_id		integer
				constraint lorsm_cmi_core_id_pk
                        	primary key
                                constraint lorsm_cmi_core_track_id_fk
                                references lorsm_student_track (track_id)
                                on delete cascade,
        authority_id            integer,
	man_id			integer,
	item_id			integer,
	student_id		varchar2(100),		-- mandatory, gettable, not settable
	student_name    	varchar2(256),		-- mandatory, gettable, not settable
	lesson_location 	varchar2(256),		-- mandatory, gettable, settable
	credit			varchar2(10)
                        	default 'no-credit',	-- mandatory, gettable, not settable
	lesson_status   	varchar2(20)
				default 'not attempted',-- mandatory, gettable, settable
	entry   		varchar2(10)
				default '',		-- mandatory, gettable, not settable
	score_raw		varchar2(10), 		-- mandatory, gettable, settable
	score_max		varchar2(10), 		-- not mandatory, gettable, settable
	score_min		varchar2(10), 		-- not mandatory, gettable, settable
	total_time              number DEFAULT 0,
    	total_time_ms           number DEFAULT 0,
	lesson_mode		varchar2(10)			
				default 'normal',	-- not mandatory, gettable, not settable
	exit			varchar2(10),	-- mandatory, not gettable, settable
	session_time            number DEFAULT 0, 	-- mandatory, not gettable, settable
   	session_time_ms         number DEFAULT 0, 	-- mandatory, not gettable, settable
	suspend_data		clob,			-- mandatory, gettable, settable
	launch_data		clob,			-- mandatory, gettable, not settable
	comments		clob,			-- not mandatory, gettable, settable
	comments_from_lms	clob,			-- not mandatory, gettable, not settable
	count_objectives        integer,                -- current number of elements in the cmi.objectives list
	count_student_data      integer,                -- is there a cmi.student_data category? (0-1)
	count_student_pref      integer,                -- is there a cmi.student_data category? (0-1)
	count_interactions      integer,                -- current number of elements in the cmi.objectives list
	time_stamp              date,                   -- time this row was written
        constraint lorsm_cmi_core_crd_ck check
                (credit in ('credit','no-credit')),
        constraint lorsm_cmi_core_stat_ck check
                (lesson_status in ('passed', 'completed','failed', 'incomplete', 'browsed', 'not attempted')),
        constraint lorsm_cmi_core_ent_ck check
                (entry in ('ab-initio', 'resume', '')),
        constraint lorsm_cmi_core_username_fk foreign key
                (authority_id, student_id) references users (authority_id, username),
        constraint lorsm_cmi_core_man_id_fk foreign key
                (man_id) references ims_cp_manifests (man_id),
        constraint lorsm_cmi_core_item_id_fk foreign key
                (item_id) references ims_cp_items(ims_item_id)
);

create index lorsm_cmi_core__stud_id_idx on lorsm_cmi_core (student_id);

comment on table lorsm_cmi_core is '
Information required to be furnished by all LMS systems. What all SCOs may depend upon at start up.
';

comment on column lorsm_cmi_core.student_id is '
Data Type: CMIIdentifier (255 alpha). Format: Up to 255 alpha-numeric characters with no spaces. Dashes (or hyphen) and the underscore are legal. Periods are illegal. Case insensitive.
';

comment on column lorsm_cmi_core.student_name is '
eg: "Student, Mike A. Jr."
';

comment on column lorsm_cmi_core.lesson_location is '
Bookmark, references course_id, cf: lorsm_st_track_course_id_fk.
';

comment on column lorsm_cmi_core.credit is '
Data Type: CMIVocabulary (Credit) - "credit" "no-credit". Currently always: "no-credit".
';

comment on column lorsm_cmi_core.lesson_status is '
Data Type: CMIVocabulary (Status) - passed completed failed incomplete browsed not attempted.
';

comment on column lorsm_cmi_core.entry is '
Data Type: CMIVocabulary (Entry) "ab-initio" "resume" "" - empty string
';

comment on column lorsm_cmi_core.score_raw is '
Data Type: CMIDecimal or CMIBlank.
Should be initialized with an empty string.
';

comment on column lorsm_cmi_core.score_max is '
Data Type: CMIDecimal or CMIBlank.
Should be initialized with an empty string.
Since this is an optional data model element, it should be returned to a _children request.
';

comment on column lorsm_cmi_core.score_min is '
Data Type: CMIDecimal or CMIBlank.
Should be initialized with an empty string.
Since this is an optional data model element, it should be returned to a _children request.
';

comment on column lorsm_cmi_core.total_time is '
Time in 1/100 sec.
Data Type: CMITimespan. Format: Hours, minutes and seconds separated by a colon. HHHH:MM:SS.SS Hours has a minimum of 2 digits and a maximum of 4 digits. Minutes shall consist of exactly 2 digits. Seconds shall contain 2 digits, with an optional decimal point and 1 or 2 additional digits. (i.e. 34.45).
';

comment on column lorsm_cmi_core.lesson_mode is '
Data Type: CMIVocabulary (Mode) "browse" "normal" "review". Currently always: "normal".
';

comment on column lorsm_cmi_core.exit is '
Data Type: CMIVocabulary (Exit) "time-out" "suspend" "logout" "".
';

comment on column lorsm_cmi_core.session_time is '
The LMS accumulates this time in cmi.core.total_time.
';

comment on column lorsm_cmi_core.suspend_data is '
Unique information generated by the SCO during previous uses that is needed for the current use.
';

comment on column lorsm_cmi_core.launch_data is '
This value should be initialized by the LMS using the manifest. The LMS should use the manifest (adlcp:datafromlms) element. If no launch data is found in the manifest, then the launch data should be set to an empty string ("").
';

comment on column lorsm_cmi_core.comments is '
Freeform feedback from the SCO. For example, the student may have the option of leaving comments at any point in the SCO, or they may be asked for comments at the end of the SCO.
';

comment on column lorsm_cmi_core.comments_from_lms is '
This element represents comments that would come from the LMS.
';

-- SCORM definition.
-- The _children keyword is used to determine all of the elements in the category that are supported by the LMS.
-- If an element has no children, but is supported, an empty string is returned. If an element is not supported,
-- an empty string is returned. A subsequent request for last error can verify that the element is not supported.

-- In our implementation all elements are supported, and empty strings are returned as long as they are not
-- initialized (without setting an error).

-- All the following tables represent optional categories.
-- Therefore the data model elements related by the columns should be returned to a _children request.

-- cmi.objectives category

create table lorsm_cmi_objectives (
	track_id	integer
                       	constraint lorsm_cmi_objs_track_id_fk
                       	references lorsm_student_track (track_id)
                        on delete cascade,
	objectives_count		integer,                                    -- start with 0
	student_id	varchar2(100),
	id		varchar2(256), 				-- not mandatory, gettable, settable
	score_raw	varchar2(10), 				-- not mandatory, gettable, settable
	score_max	varchar2(10), 				-- not mandatory, gettable, settable
	score_min	varchar2(10), 				-- not mandatory, gettable, settable
	status   	varchar2(100) 				-- not mandatory, gettable, settable
			default 'not attempted',
        constraint lorsm_cmi_objectives_status_ck check
                (status in ('passed', 'completed', 'failed', 'incomplete', 'browsed', 'not attempted')),
        constraint lorsm_cmi_objectives_id_pk primary key (track_id, objectives_count)
);


create index lorsm_cmi_obj_stud_id_idx on lorsm_cmi_objectives (student_id);

comment on table lorsm_cmi_objectives is '
Identifies how the student has performed on individual objectives covered in the SCO.
';

comment on column lorsm_cmi_objectives.id is '
An internally, developer defined, SCO specific identifier for an objective.
';

comment on column lorsm_cmi_objectives.score_raw is '
Data Type: CMIDecimal or CMIBlank. Currently always: "".
';

comment on column lorsm_cmi_objectives.score_max is '
Data Type: CMIDecimal or CMIBlank. Currently unsupported.
';

comment on column lorsm_cmi_objectives.score_min is '
Data Type: CMIDecimal or CMIBlank. Currently unsupported.
';

comment on column lorsm_cmi_objectives.status is '
The status of the SCO s objective obtained by the student after each attempt to master the SCO s objective.
Data Type: CMIVocabulary (Status) "passed" "completed" "failed" "incomplete" "browsed" "not attempted".
';

-- cmi.student_data category

create table lorsm_cmi_student_data (
	track_id		integer
				constraint lorsm_cmi_student_data_id_pk
                        	primary key
                        	constraint lorsm_cmi_st_data_track_id_fk
                        	references lorsm_student_track (track_id)
                                on delete cascade,
	student_id		varchar2(100),
	mastery_score   	varchar2(10), 				-- not mandatory, gettable, not settable
   	max_time_allowed 	varchar2(12), 			-- mandatory, not gettable, settable
	time_limit_action   	varchar2(100) 				-- not mandatory, gettable, not settable
);

create index lorsm_cmi_st_data_stud_id_idx on lorsm_cmi_student_data (student_id);

comment on table lorsm_cmi_student_data is '
Information to support customization of a SCO based on a student s performance.
 Everything here is read-only: should be set before the SCO is launched? Is it specific to the student?
';

comment on column lorsm_cmi_student_data.mastery_score is '
The passing score, as determined outside the SCO.
';

comment on column lorsm_cmi_student_data.max_time_allowed is '
amount of time the student is allowed to have in the current attempt on the SCO.
';

comment on column lorsm_cmi_student_data.time_limit_action is '
Tells the SCO what to do when the max_time_allowed is exceeded.
Data Type: CMIVocabulary (Time Limit Action)  exit,message   exit,no message   continue,message   continue,no message.
';

-- cmi.student_preference category

create table lorsm_cmi_student_preference (
	track_id	integer
			constraint lorsm_cmi_student_pref_id_pk
                        primary key
                       	constraint lorsm_cmi_st_pref_track_id_fk
                       	references lorsm_student_track (track_id)
                        on delete cascade,
	student_id	varchar2(100),
	audio		integer, 					-- not mandatory, gettable, not settable
	language	varchar2(256), 				-- not mandatory, gettable, settable
	speed		integer, 					-- not mandatory, gettable, settable
	text		integer	 				-- not mandatory, gettable, settable
);

create index lorsm_cmi_st_pref_stud_id_idx on lorsm_cmi_student_preference (student_id);

comment on table lorsm_cmi_student_preference is '
Selected options that are appropriate for subsequent SCOs
';

comment on column lorsm_cmi_student_preference.audio is '
Digit from -1 to 100 -1: is off (any negative number is an off command) 0: is a no-change status (the SCO uses its defaults or the status of the audio remains the same as the last SCO taken) 1 - 100: is volume level (1 is soft, 100 is loudest as possible)
';

comment on column lorsm_cmi_student_preference.language is '
For SCOs with multi-lingual capability, this element should be used to identify in what language the information should be delivered.
';

comment on column lorsm_cmi_student_preference.speed is '
Digit from -100 to 100 -100 is the slowest pace available in the system 0 is no-change status (The SCO uses its defaults. SCO moves at its normal speed) 100 is maximum pace available in the system.
';

comment on column lorsm_cmi_student_preference.text is '
One of three digits: -1 : text is off, not shown 0 : no change in status. Use default 1 : text is on screen, shown to student.
';

-- cmi.interactions category

create table lorsm_cmi_interactions (
	track_id		integer
                        	constraint lorsm_cmi_interact_tck_id_fk
                        	references lorsm_student_track (track_id)
                                on delete cascade,
	interactions_count		        integer,                                    -- start with 0
	student_id		varchar2(100),
	id			varchar2(256), 				-- not mandatory, not gettable, settable
	time			date, 				-- not mandatory, not gettable, settable
	type			varchar2(100), 				-- not mandatory, not gettable, settable
	weighting		varchar2(10), 				-- not mandatory, not gettable, settable
	student_response	varchar2(100), 				-- not mandatory, not gettable, settable
	result   		varchar2(10), 				-- not mandatory, not gettable, settable
	latency			integer,     				-- not mandatory, not gettable, settable
	count_objectives        integer,                                    -- current number of elements in the cmi.objectives list
	correct_responses       integer,                                    -- current number of elements in the cmi.correct_responses list
        constraint lorsm_cmi_interactions_type_ck check
        (type in ('true-false', 'choice', 'fill-in', 'matching', 'performance', 'sequencing', 'likert', 'numeric')),
	constraint lorsm_cmi_interactions_id_pk primary key (track_id, interactions_count)
);

create index lorsm_cmi_interact_stud_id_idx on lorsm_cmi_interactions (student_id);

comment on table lorsm_cmi_interactions is '
All of the items in this group are related to a recognized and recordable input from the student.
';

comment on column lorsm_cmi_interactions.id is '
Unique identifier for an interaction.
The SCO is responsible for determining this value.
';

comment on column lorsm_cmi_interactions.time is '
Identification of when the student interaction was completed.
Data Type: CMITime.
';

comment on column lorsm_cmi_interactions.type is '
Indication of which category of interaction is recorded.
Data Type: CMIVocabulary (Interaction) "true-false" "choice" "fill-in" "matching" "performance" "sequencing" "likert" "numeric".
';

comment on column lorsm_cmi_interactions.weighting is '
The weighting is a factor which is used to identify the relative importance of one interaction compared to another.
Data Type: CMIDecimal.
';

comment on column lorsm_cmi_interactions.student_response is '
Description of possible responses to the interaction.
Data Type: CMIFeedback.
';

comment on column lorsm_cmi_interactions.result is '
How the system judges the described response.
CMIVocabulary (Result) "correct" "wrong" "unanticipated" "neutral" "x.x" (CMIDecimal).
';

comment on column lorsm_cmi_interactions.latency is '
The time (in 1/100 sec) from the presentation of the stimulus to the completion of the measurable response.
Data Type: CMITimespan.
';

-- cmi.interactions.objectives list

create table lorsm_cmi_interact_objectives (
	track_id		integer
                        	constraint lorsm_cmi_int_obj_track_id_fk
                        	references lorsm_student_track (track_id),
	interaction_num	        integer,                                    -- number in the interactions list
	interactions_objectives_count		        integer,                                    -- start with 0
	student_id		varchar2(100),
	id			varchar2(256),				-- not mandatory, not gettable, settable
	constraint lorsm_cmi_interact_obj_id_pk primary key (track_id, interaction_num, interactions_objectives_count)
);

create index lorsm_cmi_int_obj_stud_id_idx on lorsm_cmi_interact_objectives (student_id);

comment on table lorsm_cmi_interact_objectives is '
Identify a list of objectives that the interaction is for.
';

comment on column lorsm_cmi_interact_objectives.id is '
Developer created identifier for an objective.
The SCO is responsible for determining this value.
';

-- cmi.correct.responses.correct_responses list

create table lorsm_cmi_int_correct_respons (
	track_id		integer
                        	constraint lorsm_cmi_i_corr_track_id_fk
                        	references lorsm_student_track (track_id)
                                on delete cascade,
	interaction_num	        integer,                                    -- number in the interactions list
	correct_responses_count		        integer,                                    -- start with 0
	student_id		varchar2(100),
	pattern			varchar2(256), 				-- not mandatory, not gettable, settable
        constraint lorsm_cmi_i_corr_id_pk primary key (track_id, interaction_num,correct_responses_count)
);

create index lorsm_cmi_int_corr_stud_id_idx on lorsm_cmi_int_correct_respons (student_id);

comment on table lorsm_cmi_int_correct_respons is '
Description of possible responses to the interaction.
';

comment on column lorsm_cmi_int_correct_respons.pattern is '
Description of possible student responses to the interaction provided by the SCO.
There may be more than one correct response, and some responses may be more correct than others.
The format is dependent on cmi.interactions.n.type.
Data Type: CMIFeedback.
';


