#!/bin/sh

# Define database parameters
HOST=
USER=
DB=mexico
export PGPASSWORD=""
TBLFILE='/Users/Nicke/desktop/dssg/mexico/data/working_folder/clues.txt'

# Old load--they updated the file and changed the structure
# psql -h $HOST -U $USER $DB <<EOF
# CREATE SCHEMA IF NOT EXISTS clues;
# DROP TABLE IF EXISTS clues.cat_of_med_units;
# CREATE TABLE clues.cat_of_med_units (
# 	latitude numeric,
# 	longitude numeric,
# 	clues_code varchar,
# 	description varchar,
# 	icon integer,
# 	clues varchar,
# 	institution varchar,
# 	clave_institution varchar,
# 	cve_entidad integer,
# 	entidad varchar,
# 	clave_municipio integer,
# 	municipio varchar,
# 	clave_localidad integer,
# 	localidad varchar,
# 	tipo_de_establecimiento varchar,
# 	clave_tipo_establecimiento varchar,
# 	tipologia_de_establecimiento varchar,
# 	nombre_del_establecimiento varchar,
# 	callle varchar,
# 	numero_exterior integer,
# 	numero_interior integer,
# 	colonia varchar,
# 	asentamiento varchar,
# 	domiiclio_completo varchar,
# 	codigo_postal varchar,
# 	estatus_de_operacion_del_establecimiento varchar,
# 	responsable_del_establecimiento varchar,
# 	lada varchar,
# 	telefono numeric,
# 	correo_electronico varchar,
# 	var_13 integer,
# 	var_14 integer,
# 	var_15 integer,
# 	var_16 integer,
# 	var_17 integer,
# 	var_18 integer,
# 	var_19 integer,
# 	var_20 integer,
# 	var_21 integer,
# 	var_22 integer,
# 	var_23 integer,
# 	var_24 integer,
# 	var_25 integer,
# 	var_26 integer,
# 	var_27 integer,
# 	var_28 integer,
# 	var_29 integer,
# 	var_30 integer,
# 	var_31 integer,
# 	var_32 integer,
# 	var_33 integer,
# 	var_34 integer,
# 	var_35 integer,
# 	var_36 integer,
# 	var_37 integer,
# 	var_38 integer,
# 	var_39 integer,
# 	var_40 integer,
# 	var_41 integer,
# 	var_42 integer,
# 	var_43 integer,
# 	var_44 integer,
# 	var_45 integer,
# 	var_46 integer,
# 	var_47 integer,
# 	var_48 integer,
# 	var_49 integer,
# 	var_50 integer,
# 	var_51 integer,
# 	var_52 integer,
# 	var_53 integer,
# 	var_54 integer,
# 	var_55 integer,
# 	var_56 integer,
# 	var_57 integer,
# 	var_58 integer,
# 	var_59 integer,
# 	var_60 integer,
# 	var_61 integer,
# 	var_62 integer,
# 	var_63 integer,
# 	var_64 integer,
# 	var_65 integer,
# 	var_66 integer,
# 	var_67 integer,
# 	var_68 integer,
# 	var_69 integer,
# 	var_70 integer,
# 	var_71 integer,
# 	var_72 integer,
# 	var_73 integer,
# 	var_74 integer,
# 	var_75 integer,
# 	var_76 integer,
# 	var_77 integer,
# 	var_78 integer,
# 	var_79 integer,
# 	var_80 integer,
# 	var_81 integer
# )
# ;
#
# \copy clues.cat_of_med_units from $TBLFILE DELIMITER ',' NULL 'NULL' CSV HEADER ENCODING 'UTF8';
# EOF
#
# # Create geometry
# psql -h $HOST -U $USER $DB <<EOF
# ALTER TABLE clues.cat_of_med_units ADD COLUMN geom geometry(POINT, 4326);
# UPDATE clues.cat_of_med_units SET geom = ST_SETSRID(ST_MakePoint(longitude, latitude), 4326);
# EOF

# New load
psql -h $HOST -U $USER $DB <<EOF
--CREATE SCHEMA IF NOT EXISTS clues;
DROP TABLE IF EXISTS clues_data;
CREATE TABLE clues_data (
	clues_code varchar,
	institution varchar,
	institution_key varchar,
	state_code varchar,
	state_name varchar,
	municipality_code varchar,
	municipality_name varchar,
	locality_code varchar,
	locality_name varchar,
	facility_type varchar,
	facility_type_key varchar,
	facility_type2 varchar,
	facility_name varchar,
	street varchar,
	exterior_number varchar,
	interior_number varchar,
	neighborhood varchar,
	settlement varchar,
	full_address varchar,
	postal_code integer,
	facility_status varchar,
	facility_head varchar,
	lada varchar,
	phone_number varchar,
	email varchar,
	latitude decimal,
	longitude decimal,
	total_locations integer,
	general_medicine_clinics integer,
	family_medicine_clinics integer,
	dental_clinics integer,
	psychology_clinics integer,
	psychiatry_clinics integer,
	other_clinics integer,
	inpatient_beds integer,
	non_hospitalization_beds integer,
	emergency_beds integer,
	short_stay_beds integer,
	pregnancy_beds integer,
	post_pregnancy_beds integer,
	intensive_care_beds integer,
	intermediate_care_beds integer,
	other_beds integer,
	newborn_beds integer,
	operating_rooms integer,
	labor_rooms integer,
	xray_systems integer,
	dental_xray_systems integer,
	pac_systems integer,
	pet_systems integer,
	linear_accelerators integer,
	angiogram_systems integer,
	c_arm_systems integer,
	hyperbaric_chambers integer,
	colposcopes integer,
	heated_babycots integer,
	incubators integer,
	echocardiographs integer,
	electrocardiographs integer,
	electroencephalographs integer,
	endoscopes integer,
	mammogram_systems integer,
	mastographs integer,
	ultrasound_systems integer,
	radiotherapy_units integer,
	mri_systems integer,
	radiology_systems integer,
	lithotriptors integer,
	hemodialysis_systems integer,
	tomography_systems integer,
	ventilators integer,
	cobalt_pumps integer,
	ambulances integer,
	doctors integer,
	general_practicioners integer,
	family_physicians integer,
	pediatricians integer,
	gynecologists integer,
	surgeons integer,
	internists integer,
	dentists integer,
	other_medical_specialists integer,
	medical_interns integer,
	dental_interns integer,
	undergraduate_interns integer,
	medical_residents integer,
	other_doctors integer,
	nurses integer,
	general_nurses integer,
	registered_nurses integer,
	intern_nurses integer,
	auxiliary_nurses integer,
	other_nurses integer,
	other_staff integer,
	total_staff integer,
	total_other_staff integer
)
;

\copy clues_data from $TBLFILE DELIMITER ',' NULL 'NULL' CSV HEADER ENCODING 'UTF8';

ALTER TABLE clues_data ADD COLUMN geom geometry(POINT, 4326);
UPDATE clues_data SET geom = ST_SETSRID(ST_MakePoint(longitude, latitude), 4326);

UPDATE clues_data
SET 
	locality_code = CASE WHEN locality_code = '9999' THEN '0000' ELSE locality_code END,
	municipality_code = CASE WHEN municipality_Code = '999' THEN '000' ELSE municipality_Code END
;

DELETE FROM clues_data
WHERE clues_code IN('MCSMP000955','ZSSSA002955','TSSMP001074','CHSSA018490','CMSMP000235','VZSSA010365','DFSSA006190')
;
EOF

