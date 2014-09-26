/***********
This script merges health sector Hospital data tables (known as BDSS/SECTOR) from 2008-2012 into one!

Original DBs are:
sector2008
sector2009
sector2010
sector2011
sector2012

Tables in each DB include: 
SECTORIAL20XX

ouput table:
layla.sector_discharges_spanish_08_12

Merged table is stored in schema named layla

***************
 Created by Layla Pournajaf
***************/
select * 
into
layla.sector_discharges_spanish_08_12
from
(select "DH", "CEDOCVE", null as "CLUES", "MOTEGRE", "SEXO", "EDAD", "EDAD1", "DIAS_ESTA",
       "AFECPRIN4", "AFECPRIN3", "GBDAFECPRIN", "CAUSABAS4", "CAUSABAS3", 
       "GBDCAUSABAS", "CASOS", "ANOCAP", "GPODIAS", "PRINPRI", 2008 as year from sector2008."SECTORIAL2008"
union all
select "DH", "CEDOCVE", "CLUES", "MOTEGRE", "SEXO", "EDAD", "EDAD1", 
       "DIAS_ESTA", "AFECPRIN4", "AFECPRIN3", "GBDAFECPRIN", "CAUSABAS4", 
       "CAUSABAS3", "GBDCAUSABAS", "CASOS", "ANOCAP", "GPODIAS", "PRINPRI",2009 as year from sector2009."SECTORIAL2009"
union all
select "DH", "CEDOCVE", "CLUES", "MOTEGRE", "SEXO", "EDAD"::int, null as "EDAD1", 
       "DIAS_ESTA", "AFECPRIN4", "AFECPRIN3", "GBDAFECPRIN", "CAUSABAS4", 
       "CAUSABAS3", "GBDCAUSABAS", "CASOS", "ANOCAP", "GPODIAS", "PRINPRI",2010 as year from sector2010."SECTORIAL2010"
union all
select "DH", "CEDOCVE", "CLUES", "MOTEGRE", "SEXO", "EDAD", "EDAD1", 
       "DIAS_ESTA", "AFECPRIN4", "AFECPRIN3", "GBDAFECPRIN", "CAUSABAS4", 
       "CAUSABAS3", "GBDCAUSABAS", "CASOS", "ANOCAP", "GPODIAS", "PRINPRI",2011 as year from sector2011."SECTORIAL2011CLUES"
union all
select "DH", "CEDOCVE", "CLUES", "MOTEGRE", "SEXO", "EDAD", "EDAD1", 
       "DIAS_ESTA", "AFECPRIN4", "AFECPRIN3", "GBDAFECPRIN", "CAUSABAS4", 
       "CAUSABAS3", "GBDCAUSABAS", "CASOS", "ANOCAP", "GPODIAS", "PRINPRI",2012 as year from sector2012."SECTORIAL2012CLUES")as temp


