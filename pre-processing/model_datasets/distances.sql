create table eric.distances as (select b.table_year as year,b.mother_res_state 
	as state_id, b.mother_res_muni as muni_id, b.mother_res_loc as 
	loc_id,
	st_distance(st_transform(l.geom,4326)::geography,c.geom::geography) as clue_distance,
	st_distance(st_transform(l.geom,4326)::geography,st_transform(m.geom, 4326)::geography) as loc_distance 
	from births_data b
	join localities l on b.mother_res_state || b.mother_res_muni || b.mother_res_loc = l.cve_loc 
	join clues_data c on b.clues_code = c.clues_code
	join localities m on c.state_code || c.municipality_code || c.locality_code = m.cve_loc 
);

