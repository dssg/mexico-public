/***********
This script translates the column names of the merged table form health sector hospital data known as (BDSS) to english!

Spanish-version merged table is:

layla.sector_discharges_spanish_08_12

Translations will be in: 

layla.sector_discharges_08_12

all generated tables are stored in schema named layla

***************
 Created by Layla Pournajaf
***************/
SELECT year,"DH" as insurance, "CEDOCVE" as state_code, "CLUES" as clue_code, "MOTEGRE" as discharge_reason, "SEXO" as sex, "EDAD1" as age, "EDAD" as age_code, 
       "DIAS_ESTA" as days_stay, "AFECPRIN4" as main_condition_3digit_icd10, "AFECPRIN3" as main_condition_2digit_icd10, "GBDAFECPRIN" as main_condition_gbdmorbi_code, "CAUSABAS4" as main_condition_4digit_gbdmorbi, 
       "CAUSABAS3" as main_condition_3digit_gbdmorbi, "GBDCAUSABAS" as basic_cause_gbdmorbi_code, "CASOS" as number_of_cases, "ANOCAP" as record_year, "GPODIAS" as day_group_code, "PRINPRI" as main_hospitalization_reason
into layla.sector_discharges_08_12
FROM layla.sector_discharges_spanish_08_12;