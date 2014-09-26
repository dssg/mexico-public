/***********
This script merges SSA Hospital data tables (known as SAEH) from 2010-2013 into one for each table!

Original DBs are:
saeh_10
saeh_11
saeh_12
saeh_13

Tables in each DB include: 
AFECCIONES: Conditions, 
PRODUCTOS: Fetuses, 
DEFUNC: Deaths, 
OBSTET: Obstetrics, 
PROCEDIMIENTOS: Procedures, 
EGRESO : Discharges

Merged tables are stored in schema named layla

***************
 Created by Layla Pournajaf
***************/

select *
into layla.saeh_conditions_spanish_10_13
from
(
select 2010 as year,null as "FOLIO",null as "EGRESO",null as "CLUES",* from saeh_10."AFECCIONES"
union all
select 2011 as year,"FOLIO","EGRESO","CLUES","ID","AFEC","NUMAFEC" from saeh_11."AFECCIONES"
union all
select 2012 as year,"FOLIO","EGRESO","CLUES","ID","AFEC","NUMAFEC" from saeh_12."AFECCIONES"
union all
select 2013 as year,null as FOLIO,null as EGRESO,null as CLUES,* from saeh_13."AFECCIONES"
) as temp;


select *
into layla.saeh_fetuses_spanish_10_13
from
(
select 2010 as year,null as "FOLIO",null as "EGRESO",null as "CLUES",* from saeh_10."PRODUCTOS"
union all
select 2011 as year, "FOLIO", "EGRESO", "CLUES", "ID","NUMPRODUCTO", "PESOPROD", "SEXPROD", 
       "CONDNAC", "CONDEGRE", "NAVIAPAG", "NAVIREAN", "NAVICUNE" from saeh_11."PRODUCTOS"
union all
select 2012 as year,"FOLIO", "EGRESO", "CLUES", "ID","NUMPRODUCTO", "PESOPROD", "SEXPROD", 
       "CONDNAC", "CONDEGRE", "NAVIAPAG", "NAVIREAN", "NAVICUNE" from saeh_12."PRODUCTOS"
union all
select 2013 as year,null as FOLIO,null as EGRESO,null as CLUES,* from saeh_13."PRODUCTOS"
) as temp;

select *
into layla.saeh_deaths_spanish_10_13
from
(
select 2010 as year,null as "FOLIO",null as "EGRESO",null as "CLUES",* from saeh_10."DEFUNC"
union all
select 2011 as year,"FOLIO", "EGRESO", "CLUES","ID", "MP", "CAUSAIA", "CVETIEMIA", "TIEMPOIA", "CAUSAIB", "CVETIEMIB", 
       "TIEMPOIB", "CAUSAIC", "CVETIEMIC", "TIEMPOIC", "CAUSAID", "CVETIEMID", 
       "TIEMPOID", "CAUSAIIA", "CVETIEMIIA", "TIEMPOIIA", "CAUSAIIB", 
       "CVETIEMIIB", "TIEMPOIIB", "CAUSABAS" from saeh_11."DEFUNC"
union all
select 2012 as year,"FOLIO", "EGRESO", "CLUES","ID", "MP", "CAUSAIA", "CVETIEMIA", "TIEMPOIA", "CAUSAIB", "CVETIEMIB", 
       "TIEMPOIB", "CAUSAIC", "CVETIEMIC", "TIEMPOIC", "CAUSAID", "CVETIEMID", 
       "TIEMPOID", "CAUSAIIA", "CVETIEMIIA", "TIEMPOIIA", "CAUSAIIB", 
       "CVETIEMIIB", "TIEMPOIIB", "CAUSABAS" from saeh_12."DEFUNC"
union all
select 2013 as year,null as "FOLIO",null as "EGRESO",null as "CLUES",* from saeh_13."DEFUNC"
) as temp;


select *
into layla.saeh_obstetrics_spanish_10_13
from
(
select 2010 as year,null as "FOLIO",null as "EGRESO",null as "CLUES",* from saeh_10."OBSTET"
union all
select 2011 as year,"FOLIO", "EGRESO", "CLUES","ID", "GESTAS", "PARTOS", "ABORTOS", "HAYPROD", "TIPATEN", "GESTAC", 
       "PRODUCTO", "TIPNACI", "PLANFAM" from saeh_11."OBSTET"
union all
select 2012 as year,"FOLIO", "EGRESO", "CLUES","ID", "GESTAS", "PARTOS", "ABORTOS", "HAYPROD", "TIPATEN", "GESTAC", 
       "PRODUCTO", "TIPNACI", "PLANFAM" from saeh_12."OBSTET"
union all
select 2013 as year,null as "FOLIO",null as "EGRESO",null as "CLUES",* from saeh_13."OBSTET"
) as temp;


select *
into layla.saeh_procedures_spanish_10_13
from
(
select 2010 as year,null as "FOLIO",null as "EGRESO",null as "CLUES",* from saeh_10."PROCEDIMIENTOS"
union all
select 2011 as year,"FOLIO", "EGRESO", "CLUES","ID","NUMPROMED", "PROMED", 
       "ANEST", "QUIROF", "QH", "QM","TIPO" from saeh_11."PROCEDIMIENTOS"
union all
select 2012 as year,"FOLIO", "EGRESO", "CLUES","ID","NUMPROMED", "PROMED", 
       "ANEST", "QUIROF", "QH", "QM","TIPO" from saeh_12."PROCEDIMIENTOS"
union all
select 2013 as year,null as "FOLIO",null as "EGRESO",null as "CLUES",* from saeh_13."PROCEDIMIENTOS"
) as temp;


select *
into layla.saeh_discharges_spanish_10_13
from
(
select 2010 as year, null as "CEDOCVE", null as "CJURCVE", null as "CMPOCVE", null as "CLOCCVE", null as "CTUNCVE",
       "ID", "CLUES", "FOLIO", "EGRESO", "INGRE", "DIAS_ESTA", "TUHPSIQ", 
       "SERVHC", "SERVHP", "CVEEDAD", "EDAD", "NACIOEN", "SEXO", "PESO", 
       "TALLA", "DERHAB", "ENTIDAD", "MUNIC", "LOC", "INDIGENA", "HABLA_LENGUA", 
       "LENGUA_INDIGENA", "HABLA_ESP", "TIPSERV", "SERVICIOINGRE", "SERVICIO02", 
       "SERVICIO03", "SERVICIOEGRE", "SA_LABOR", "SA_EXPUL", "SA_RECUP", 
       "SA_INTEN", "SA_INTERM", "PROCED", "CLUESPROCED", "MOTEGRE", 
       "CLUESREFERIDO", "DIAG_INI", "AFECPRIN", "VEZ", "INFEC", "CAUSAEXT", 
       "TRAUMAT", "LUGAR", "MES_ESTADISTICO", "SEGUNDA_AFECCION"
	from saeh_10."EGRESO"
union all
select 2011 as year,"CEDOCVE", "CJURCVE", "CMPOCVE","CLOCCVE", "CTUNCVE", "ID", "CLUES", "FOLIO", "EGRESO", "INGRE", "DIAS_ESTA", "TUHPSIQ", 
       "SERVHC", "SERVHP", "CVEEDAD", "EDAD", "NACIOEN", "SEXO", "PESO", 
       "TALLA", "DERHAB", "ENTIDAD", "MUNIC", "LOC", "INDIGENA", "HABLA_LENGUA", 
       "LENGUA_INDIGENA", "HABLA_ESP", "TIPSERV", "SERVICIOINGRE", "SERVICIO02", 
       "SERVICIO03", "SERVICIOEGRE", "SA_LABOR", "SA_EXPUL", "SA_RECUP", 
       "SA_INTEN", "SA_INTERM", "PROCED", "CLUESPROCED", "MOTEGRE", 
       "CLUESREFERIDO", "DIAG_INI", "AFECPRIN", "VEZ", "INFEC", "CAUSAEXT", 
       "TRAUMAT", "LUGAR", "MES_ESTADISTICO",null as "SEGUNDA_AFECCION" from saeh_11."EGRESO"
union all
select 2012 as year,"CEDOCVE", "CJURCVE", "CMPOCVE","CLOCCVE", "CTUNCVE", "ID", "CLUES", "FOLIO", "EGRESO", "INGRE", "DIAS_ESTA", "TUHPSIQ", 
       "SERVHC", "SERVHP", "CVEEDAD", "EDAD", "NACIOEN", "SEXO", "PESO", 
       "TALLA", "DERHAB", "ENTIDAD", "MUNIC", "LOC", "INDIGENA", "HABLA_LENGUA", 
       "LENGUA_INDIGENA", "HABLA_ESP", "TIPSERV", "SERVICIOINGRE", "SERVICIO02", 
       "SERVICIO03", "SERVICIOEGRE", "SA_LABOR", "SA_EXPUL", "SA_RECUP", 
       "SA_INTEN", "SA_INTERM", "PROCED", "CLUESPROCED", "MOTEGRE", 
       "CLUESREFERIDO", "DIAG_INI", "AFECPRIN", "VEZ", "INFEC", "CAUSAEXT", 
       "TRAUMAT", "LUGAR", "MES_ESTADISTICO",null as "SEGUNDA_AFECCION" from saeh_12."EGRESO"
union all
select 2013 as year,"CEDOCVE", "CJURCVE", "CMPOCVE","CLOCCVE", null as "CTUNCVE", "ID", "CLUES", "FOLIO", "EGRESO", "INGRE", "DIAS_ESTA", "TUHPSIQ", 
       "SERVHC", "SERVHP", "CVEEDAD", "EDAD", "NACIOEN", "SEXO", "PESO", 
       "TALLA", "DERHAB", "ENTIDAD", "MUNIC", "LOC", "INDIGENA", "HABLA_LENGUA", 
       "LENGUA_INDIGENA", "HABLA_ESP", "TIPSERV", "SERVICIOINGRE", "SERVICIO02", 
       "SERVICIO03", "SERVICIOEGRE", "SA_LABOR", "SA_EXPUL", "SA_RECUP", 
       "SA_INTEN", "SA_INTERM", "PROCED", "CLUESPROCED", "MOTEGRE", 
       "CLUESREFERIDO", "DIAG_INI", "AFECPRIN", "VEZ", "INFEC", "CAUSAEXT", 
       "TRAUMAT", "LUGAR", "MES_ESTADISTICO"::text, null as "SEGUNDA_AFECCION"
	from saeh_13."EGRESO"
) as temp;