/***********
This script calculates distances between hopitals to residence of individuals using maternal data (Secretaria de Salud hospital data known as (SAEH)) for indiviual-level modeling!

input tables are:

layla.saeh_maternal_10_13 
categories (cat_saeh_13)
clues_data
localities

The ouput is stored as: 
layla.saeh_distances_10_13 

all tables are stored in schema named layla

***************
 Created by Layla Pournajaf
***************/

create table layla.saeh_distances_10_13 as
select sa.id as id, sa.year as year, coalesce(sa.clue_state,c.state_code,cat_c."cve_Ent") as clue_state, coalesce(sa.clue_municipality,c.municipality_code,cat_c."cve_mun") as clue_municipality,coalesce(sa.clue_locality,c.locality_code,cat_c."cve_loc") as clue_locality, 
	st_distance(st_transform(l.geom,4326)::geography,c.geom::geography) as clue_distance,
	st_distance(st_transform(l.geom,4326)::geography,st_transform(m.geom, 4326)::geography) as loc_distance 
	from layla.saeh_maternal_10_13 sa
	left join localities l on sa.state_residence || sa.municipality_residence || sa.locality_residence = l.cve_loc 
	left join clues_data c on sa.clue_code = c.clues_code
	left join cat_saeh_13."CATCLUES" cat_c on sa.clue_code = cat_c."CLUES"
	left join localities m on coalesce(sa.clue_state,c.state_code,cat_c."cve_Ent") || coalesce(sa.clue_municipality,c.municipality_code,cat_c."cve_mun") || coalesce(sa.clue_locality,c.locality_code,cat_c."cve_loc")  = m.cve_loc;

