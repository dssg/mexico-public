/***********
This script translates the column names of the merged tables form Secretaria de Salud hospital data known as (SAEH) to english!

Spanish-version merged tables are:

layla.saeh_conditions_spanish_10_13
layla.saeh_fetuses_spanish_10_13
layla.saeh_deaths_spanish_10_13
layla.saeh_obstetrics_spanish_10_13
layla.saeh_procedures_spanish_10_13
layla.saeh_discharges_spanish_10_13

Translations will be in: 

layla.saeh_conditions_10_13
layla.saeh_fetuses_10_13
layla.saeh_deaths_10_13
layla.saeh_obstetrics_10_13
layla.saeh_procedures_10_13
layla.saeh_discharges_10_13

Merged tables are stored in schema named layla

***************
 Created by Layla Pournajaf
***************/

SELECT year,"CEDOCVE" as clue_state, "CJURCVE" as clue_jurisdiction, "CMPOCVE" as clue_municipality, "CLOCCVE" as clue_locality, "CTUNCVE" as clue_type, "CLUES" as clue_code, 
       "FOLIO" as folio, "EGRESO" as discharge_date, "INGRE" as entrance_date, "DIAS_ESTA" as days_stay, "TUHPSIQ", "SERVHC", 
       "SERVHP", "CVEEDAD" as age_code, "EDAD" as age_at_discharge, "NACIOEN" as born_in_hospital, "SEXO" as sex_code, "PESO" as weight_kg, "TALLA" as height_cm, 
       "DERHAB" as insurance, "ENTIDAD" as state_residence, "MUNIC" as municipality_residence, "LOC" as locality_residence, "INDIGENA" as native, "HABLA_LENGUA" as speaks_native, 
       "LENGUA_INDIGENA" as native_language, "HABLA_ESP" speaks_spanish, "TIPSERV" as entrance_service_type, "SERVICIOINGRE" as entrance_service_code, "SERVICIO02" as service_2_code, 
       "SERVICIO03" as service_3_code, "SERVICIOEGRE" as discharge_service_code, "SA_LABOR" as labor_room_hours, "SA_EXPUL" as delivery_room_hours, "SA_RECUP" as recovery_room_hours, 
       "SA_INTEN" as intensive_care_hours, "SA_INTERM" intermediate_care_hours, "PROCED" as entrance_origin, "CLUESPROCED" as clues_referred_by, "MOTEGRE" as discharge_reason, 
       "CLUESREFERIDO" as clues_referred_to, "DIAG_INI" as initial_diagnosis_icd10, "AFECPRIN" as main_condition_icd10, "VEZ" as first_visit, "INFEC" as infection, "CAUSAEXT" as external_cause_icd10, 
       "TRAUMAT" as trauma_type, "LUGAR" as place_trauma_happened, "ID" as id, "MES_ESTADISTICO" as statistics, "SEGUNDA_AFECCION" as second_condition
into layla.saeh_discharges_10_13
from layla.saeh_discharges_spanish_10_13;

SELECT year,"CLUES" as clue_code, "FOLIO" as folio, "EGRESO" as discharge_date, "AFEC" as cause_icd10, "NUMAFEC" as condition_no, "ID" as id
into layla.saeh_conditions_10_13
FROM layla.saeh_conditions_spanish_10_13;

SELECT year,"CLUES" as clue_code, "FOLIO" as folio, "EGRESO" as discharge_date, "MP" as death_certificate_existence, "CAUSAIA" as cause_icd10_1, "CVETIEMIA" as cause_time_code_1, "TIEMPOIA" as cause_time_1, 
       "CAUSAIB" as cause_icd10_2, "CVETIEMIB" as cause_time_code_2, "TIEMPOIB" as cause_time_2, "CAUSAIC" as cause_icd10_3, "CVETIEMIC" as cause_time_code_3, "TIEMPOIC" as cause_time_3, 
       "CAUSAID" as cause_icd10_4, "CVETIEMID" as cause_time_code_4, "TIEMPOID" as cause_time_4, "CAUSAIIA" as cause_icd10_5, "CVETIEMIIA" as cause_time_code_5, 
       "TIEMPOIIA" as cause_time_5, "CAUSAIIB" as cause_icd10_6, "CVETIEMIIB" as cause_time_code_6, "TIEMPOIIB" as cause_time_6, "CAUSABAS" as basic_cause_icd10, 
       "ID" as id
  into layla.saeh_deaths_10_13     
  FROM layla.saeh_deaths_spanish_10_13;

SELECT year,"CLUES" as clue_code, "FOLIO" as folio, "EGRESO" as discharge_date, "NUMPROMED" as emergency_proc_no, "PROMED" as proc_code_icd9, "ANEST" as anethesia_type, "QUIROF" as operating_room_use, 
       "QH" as hour_in_room, "QM" as min_in_room, "ID" as id, "TIPO" as proc_type
  into layla.saeh_procedures_10_13
  FROM layla.saeh_procedures_spanish_10_13;


SELECT year,"CLUES" as clue_code, "FOLIO" as folio, "EGRESO" as discharge_date, "GESTAS" as pregnancy_bk_no, "PARTOS" as births_bk_no, "ABORTOS" as abortion_bk_no, "HAYPROD" as fetus_expelled, 
       "TIPATEN" as care_type, "GESTAC" as gestation_weeks, "PRODUCTO" as single_multiple_fetus, "TIPNACI" as birth_type, "PLANFAM" as family_plan_type, "ID" as id
  into layla.saeh_obstetrics_10_13
  FROM layla.saeh_obstetrics_spanish_10_13;


SELECT year,"CLUES" as clue_code, "FOLIO" as folio, "EGRESO" as discharge_date, "NUMPRODUCTO" as fetus_no, "PESOPROD" as weight, "SEXPROD" as sex, 
       "CONDNAC" as condition_birth, "CONDEGRE" as condition_discharge, "NAVIAPAG" as medical_score, "NAVIREAN" as resuscitation, "NAVICUNE" as bassinet_hours, "ID" as id
  into layla.saeh_fetuses_10_13
  FROM layla.saeh_fetuses_spanish_10_13;


