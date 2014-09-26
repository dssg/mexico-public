DROP TABLE IF EXISTS eric.basico_distance;

create table eric.basico_distance as 
    (select l.cve_loc, l.clues_code, l.non_basico_clues_code, 
    st_distance(st_transform(l.geom,4326)::geography,c.geom::geography) as clue_distance,
    st_distance(st_transform(l.geom,4326)::geography,c2.geom::geography) as non_basico_clue_distance,
    st_distance(st_transform(l.geom,4326)::geography,c3.geom::geography) as imss_clue_distance,
    st_distance(st_transform(l.geom,4326)::geography,c4.geom::geography) as ssa_clue_distance,
	(l.con_ubic = 0) as urban
	from 
		(select *, (select clues_code from clues_data c 
   		where facility_type2 not like '%01%' order by 
    	st_transform(l.geom,4326)<->c.geom limit 1) as non_basico_clues_code,
		(select clues_code from clues_data c 
   		where institution_key = 'IMSS' order by 
    	st_transform(l.geom,4326)<->c.geom limit 1) as imss_clues_code,
		(select clues_code from clues_data c 
   		where institution_key = 'SSA' order by 
    	st_transform(l.geom,4326)<->c.geom limit 1) as ssa_clues_code,
    	(select clues_code from clues_data c order by 
    	st_transform(l.geom,4326)<->c.geom limit 1) as clues_code
		from localities l) l
    join clues_data c on (l.clues_code = c.clues_code)
	join clues_data c2 on (c2.clues_code = l.non_basico_clues_code)
	join clues_data c3 on (c3.clues_code = l.imss_clues_code)
	join clues_data c4 on (c4.clues_code = l.ssa_clues_code)
);
