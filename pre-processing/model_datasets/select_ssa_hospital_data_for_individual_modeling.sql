/***********
This script selects a set of features form maternal data (Secretaria de Salud hospital data known as (SAEH)) for indiviual-level modeling!
To avoid information of multiple visits, we only select a visit which leads to 
a delivery or abortion - > (expelled_fetus_count > 0),
or death --> (dead = 1)

input tables are:

layla.saeh_maternal_10_13 
layla.saeh_distances_10_13 


The ouput is stored as: 

layla.saeh_model_10_13 

all tables are stored in schema named layla

***************
 Created by Layla Pournajaf
***************/


SELECT ma.year, 
	/*clue_state, clue_jurisdiction, */
	concat(di.clue_state,di.clue_municipality) as muni_clue, 
	di.clue_distance,
	di.loc_distance,
	/*clue_locality,*/ 
       clue_type, 
       /*clue_code, folio, discharge_date, entrance_date,*/ 
       days_stay, 
       /*"TUHPSIQ", "SERVHC", "SERVHP",*/ 
       age_code, age_at_discharge, 
       /* born_in_hospital, */
       /*sex_code, */
       weight_kg, 
       height_cm, 
       insurance, 
       /*state_residence, */
       concat(state_residence,municipality_residence) as muni_res,/* 
       locality_residence, */
       native, speaks_native, 
       /*native_language,*/ 
       speaks_spanish, 
       entrance_service_type, 
       entrance_service_code, 
       /*service_2_code, 
       service_3_code,*/ 
       discharge_service_code, 
       labor_room_hours, 
       delivery_room_hours, 
       recovery_room_hours, 
       intensive_care_hours, 
       intermediate_care_hours, 
       entrance_origin, /*clues_referred_by, discharge_reason, clues_referred_to,*/ 
       upper(substring(initial_diagnosis_icd10 from 1 for 3)) as initial_diagnosis_icd10, 
       upper(substring(main_condition_icd10 from 1 for 3)) as main_condition_icd10, 
       first_visit, 
       infection, 
       upper(substring(external_cause_icd10 from 1 for 3)) as external_cause_icd10, 
       trauma_type, 
       place_trauma_happened,
       /* id,*/ 
       statistics, 
       second_condition, 
       /*insurance_name,*/
       pregnancy_bk_no, 
       births_bk_no, 
       abortion_bk_no, 
       fetus_expelled, 
       care_type, 
       gestation_weeks, 
       single_multiple_fetus, 
       birth_type, 
       family_plan_type, 
       /*death_certificate_existence, 
       cause_icd10_1, cause_time_code_1, cause_time_1, cause_icd10_2, 
       cause_time_code_2, cause_time_2, cause_icd10_3, cause_time_code_3, 
       cause_time_3, cause_icd10_4, cause_time_code_4, cause_time_4, 
       cause_icd10_5, cause_time_code_5, cause_time_5, cause_icd10_6, 
       cause_time_code_6, cause_time_6, basic_cause_icd10,*/ 
       dead, 
       actual_births, 
       expelled_fetus_count
into layla.saeh_model_10_13     
FROM layla.saeh_maternal_10_13 ma
inner join layla.saeh_distances_10_13 di on ma.year = di.year and ma.id = di.id
where ma.expelled_fetus_count > 0 or ma.dead = 1
