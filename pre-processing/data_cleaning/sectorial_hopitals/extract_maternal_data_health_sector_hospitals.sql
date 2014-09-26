/***********
This script extracted maternal data form health sector hospital data known as (BDSS/Sectorial)!

input table:

layla.sector_discharges_08_12

The ouput is stored as: 

layla.sector_maternal_09_12 

all tables are stored in schema named layla

***************
 Created by Layla Pournajaf
***************/

select 
year,
age,
days_stay,
dis.state_code,
clu.municipality_code as muni_code,
concat(concat(clu.state_name,'_'),clu.municipality_name) as state_muni_name, 
clue_code,
clu.facility_type2 as clue_type,
ins."Descripcion" as insurance,
case when discharge_reason::int = 5 then 1 else 0 end as dead, 
reasons."Descrip" as discharge_reason, 
icd10.code3_description as main_condition, 
dis.main_condition_2digit_icd10 as main_condition_code3,
dis.main_condition_3digit_icd10 as main_condition_code4,

case when upper(dis.main_condition_2digit_icd10) = 'O82' or upper(dis.main_condition_3digit_icd10) = 'O842' then 'c_section' 
else 
case when upper(dis.main_condition_2digit_icd10) = 'O80' or upper(dis.main_condition_3digit_icd10) = 'O840' then 'natural' 
else 
case when upper(dis.main_condition_2digit_icd10) = 'O81' or upper(dis.main_condition_3digit_icd10) = 'O841' then 'forceps' 
else 
case when upper(dis.main_condition_2digit_icd10) = 'O83' or upper(dis.main_condition_3digit_icd10) = 'O848' then 'other_assisted' 
else 
case when upper(dis.main_condition_3digit_icd10) = 'O849' then 'unspecified' 
else 'not_delivery' end end end end end as delivery_type,

case when upper(dis.main_condition_2digit_icd10) = 'O80' or upper(dis.main_condition_2digit_icd10) = 'O81' or upper(dis.main_condition_2digit_icd10) = 'O82' or upper(dis.main_condition_2digit_icd10) = 'O83' then 'single' 
else 
case when upper(dis.main_condition_2digit_icd10) = 'O84' then 'multiple' 
else 
'not_delivery' end end as delivery_single_multi, 

case when upper(dis.main_condition_2digit_icd10) = 'O80' or upper(dis.main_condition_2digit_icd10) = 'O81' or upper(dis.main_condition_2digit_icd10) = 'O82' or upper(dis.main_condition_2digit_icd10) = 'O83' or upper(dis.main_condition_2digit_icd10) = 'O84' 
then 1 else 0 end as delivery, 

case when upper(dis.main_condition_3digit_icd10) = 'O820' then 'elective' 
else
case when upper(dis.main_condition_3digit_icd10) = 'O821' then 'emergency'
else
case when upper(dis.main_condition_3digit_icd10) = 'O822' then 'hysterectomy'
else 
case when upper(dis.main_condition_3digit_icd10) = 'O828' then 'other_type'
else
case when upper(dis.main_condition_3digit_icd10) = 'O829' then 'unspecified'
else 'unspecified' end end end end end as c_section_type,

case when upper(dis.main_condition_2digit_icd10) = 'O00' or upper(dis.main_condition_2digit_icd10) = 'O01' or upper(dis.main_condition_2digit_icd10) = 'O02' or upper(dis.main_condition_2digit_icd10) = 'O03' or upper(dis.main_condition_2digit_icd10) = 'O04' or upper(dis.main_condition_2digit_icd10) = 'O05'
or upper(dis.main_condition_2digit_icd10) = 'O06' or upper(dis.main_condition_2digit_icd10) = 'O07' or upper(dis.main_condition_2digit_icd10) = 'O08' then 1 else 0 end as abortion


into layla.sector_maternal_09_12

from layla.sector_discharges_08_12 as dis 
left join sector2012."CatInstituciones" as ins on dis.insurance = ins."DH"
left join sector2012."CatMotEgreso" as reasons on dis.discharge_reason = reasons."IDCatMotEgreso"
left join clues_data clu on clu.clues_code = dis.clue_code
left join icd10_3 as icd10 on substring(dis.main_condition_2digit_icd10 from 1 for 3) = icd10.icd_10_3
where (upper(substring(dis.main_condition_3digit_icd10 from 1 for 1))= 'O' or upper(substring(dis.main_condition_2digit_icd10 from 1 for 1))= 'O') and year > 2008 

/*Pregnancy resulting in abortion
O00-O08


O80

Single spontaneous delivery


O81

Single delivery by forceps and vacuum extractor

O82

Single delivery by caesarean section



O82.0

Delivery by elective caesarean section
Repeat caesarean section NOS


O82.1

Delivery by emergency caesarean section



O82.2

Delivery by caesarean hysterectomy



O82.8

Other single delivery by caesarean section



O82.9

Delivery by caesarean section, unspecified


O83

Other assisted single delivery


O84

Multiple delivery
Use additional code (O80-O83), if desired, to indicate the method of delivery of each fetus or infant.


O84.0

Multiple delivery, all spontaneous



O84.1

Multiple delivery, all by forceps and vacuum extractor



O84.2

Multiple delivery, all by caesarean section



O84.8

Other multiple delivery
Multiple delivery by combination of methods


O84.9

Multiple delivery, unspecified



*/


