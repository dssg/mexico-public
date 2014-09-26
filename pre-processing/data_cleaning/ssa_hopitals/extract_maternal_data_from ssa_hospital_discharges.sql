/***********
This script joins several translated tables form Secretaria de Salud hospital data known as (SAEH) and extracts maternal data!

joined tables are:

layla.saeh_fetuses_10_13
layla.saeh_deaths_10_13
layla.saeh_obstetrics_10_13
layla.saeh_discharges_10_13

The ouput is stored as: 

layla.saeh_maternal_10_13 

all tables are stored in schema named layla

***************
 Created by Layla Pournajaf
***************/

select * into layla.saeh_maternal_10_13 
from
(select dis.*,cat_ins."Descrip" as insurance_name,
       ob.pregnancy_bk_no, ob.births_bk_no, 
       ob.abortion_bk_no, ob.fetus_expelled, ob.care_type, ob.gestation_weeks, ob.single_multiple_fetus, 
       ob.birth_type, ob.family_plan_type, 
       de.death_certificate_existence, 
       de.cause_icd10_1, de.cause_time_code_1, de.cause_time_1, de.cause_icd10_2, 
       de.cause_time_code_2, de.cause_time_2, de.cause_icd10_3, de.cause_time_code_3, 
       de.cause_time_3, de.cause_icd10_4, de.cause_time_code_4, de.cause_time_4, 
       de.cause_icd10_5, de.cause_time_code_5, de.cause_time_5, de.cause_icd10_6, 
       de.cause_time_code_6, de.cause_time_6, de.basic_cause_icd10, case when de.id is null then 0 else 1 end as dead,
       coalesce(fe.actual_births,0) as actual_births, coalesce(fe.fetus_count,0) as fetus_count
from layla.saeh_discharges_10_13 as dis inner join layla.saeh_obstetrics_10_13 as ob on dis.id = ob.id and dis.year = ob.year
left join layla.saeh_deaths_10_13 as de on dis.id = de.id and dis.year = de.year
left join 
(select year,id,sum((case when condition_discharge::int < 3 then 1 else 0 end)) as actual_births,count(*) as expelled_fetus_count
from layla.saeh_fetuses_10_13
group by id,year) as fe 
on dis.id = fe.id and dis.year=fe.year
left join cat_saeh_13."CATDEREC" as cat_ins on substring(cat_ins."LLAVEDER"::text from 1 for 1) = substring(dis.insurance::text from 1 for 1)
) as merged
 
/*
condition_discharge for fetuses: 1,2: alive 3:dead 9: N.E.
*/