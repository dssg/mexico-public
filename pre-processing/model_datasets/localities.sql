-- NOTE THAT WHEN USING THIS SCRIPT YOU WILL GET LOCALITIES THAT APPEAR IN SOME DATASETS BUT DON'T APPEAR IN OTHERS. BE SURE TO SUBSET OUT ONLY THE STUFF YOU WANT.
SELECT
	locality,
	localities_census.nom_ent,
	localities_census.nom_mun,
	localities_census.nom_loc,
	localities_census.cabecera,
	localities_census.urban,
	localities_census.pob1,
	localities_census.pob42,
	localities_census.pob31,
	localities_census.ent,
	localities_census.mun,
	localities_info.pob_tot,
	localities_info.occupied_dwellings, 
	localities_info.no_read, 
	localities_info.no_ed, 
	localities_info.no_toilet, 
	localities_info.no_electricity, 
	localities_info.no_water, 
	localities_info.people_per_room, 
	localities_info.dirt_floor, 
	localities_info.no_fridge, 
	localities_info.margination, 
	localities_info.margination_degree, 
	localities_info.urbanicity,
	COALESCE(deaths_data.deaths, 0) as deaths,
	COALESCE(clues_data.num_institutions, 0) as num_institutions,
	COALESCE(clues_data.other_institutions, 0) as other_institutions,
	COALESCE(clues_data.imss_issste_institutions, 0) as imss_issste_institutions,
	COALESCE(clues_data.estatal_municipal_institutions, 0) as estatal_municipal_institutions,
	COALESCE(clues_data.private_institutions, 0) as private_institutions,
	COALESCE(clues_data.ssa_institutions, 0) as ssa_institutions,
	COALESCE(clues_data.rural_class_institutions, 0) as rural_class_institutions,
	COALESCE(clues_data.urban_class_institutions, 0) as urban_class_institutions,
	COALESCE(clues_data.pregnancy_beds, 0) as pregnancy_beds,
	COALESCE(clues_data.post_pregnancy_beds, 0) as post_pregnancy_beds,
	COALESCE(clues_data.newborn_beds, 0) as newborn_beds,
	COALESCE(clues_data.labor_rooms, 0) as labor_rooms,
	COALESCE(clues_data.ultrasound_systems, 0) as ultrasound_systems,
	COALESCE(clues_data.doctors, 0) as doctors,
	COALESCE(clues_data.family_physicians, 0) as family_physicians,
	COALESCE(clues_data.gynecologists, 0) as gynecologists,
	COALESCE(clues_data.nurses, 0) as nurses
FROM(
	SELECT locality, nom_ent, nom_mun, nom_loc, cabecera, urban,
	    CASE WHEN pob1 >= 0 THEN pob1 ELSE NULL END as pob1,
	    CASE WHEN pob42 >= 0 THEN pob42 ELSE NULL END as pob42,
	    CASE WHEN pob31 >= 0 THEN pob31 ELSE NULL END as pob31,
	    substring(locality, 1, 2) as ent,
	    substring(locality, 3, 3) as mun
	FROM (
	    SELECT cvegeo as locality, nom_ent, nom_mun, nom_loc, pob1, pob42, pob31,
	        NULL AS cabecera,
	        0 as urban
	    FROM census.national_loc_rur
	    UNION ALL
	    SELECT cvegeo as locality, nom_ent, nom_mun, nom_loc, pob1, pob42, pob31,
	        cabecera,
	        1 as urban
	    FROM census.national_loc_urb
	) as localities_census
) as localities_census
FULL OUTER JOIN(
	SELECT cve_loc as locality, 
		pob_tot, 
		vpha as occupied_dwellings, 
		ana_10 as no_read, 
		snprim10 as no_ed, 
		snexc10 as no_toilet, 
		snee10 as no_electricity, 
		sague10 as no_water, 
		prom_oc10 as people_per_room, 
		pisoter10 as dirt_floor, 
		snref10 as no_fridge, 
		im_2010 as margination, 
		gm_2010 as margination_degree, 
		con_ubic as urbanicity
	FROM localities
) as localities_info
USING(locality)
FULL OUTER JOIN(
	SELECT
	    count(*) as deaths,
	    concat(residence_state, residence_municipality, residence_locality) as locality
	FROM maternal_mortality_data
	WHERE dod_year >= 2009 AND dod_year <= 2012
	GROUP BY 
	    locality
) AS deaths_data
USING(locality)
FULL OUTER JOIN(
	SELECT CONCAT(state_code, municipality_code, locality_code) as locality,
		count(*) as num_institutions,
		SUM((institution_key IN('CRUZ ROJA', 'DIF', 'PEMEX', 'UNIVERSITARIO', 'PRIVADA'))::int) as private_other_institutions,
		SUM((institution_key IN('IMSS', 'ISSSTE', 'SCT', 'SEDENA', 'SEMAR'))::int) as employed_institutions,
		SUM((institution_key IN('ESTATAL', 'MUNICIPAL', 'SSA'))::int) as ssa_institutions,
		SUM((institution_key IN('IMSS-OPORTUNIDADES'))::int) as opportunidades_institutions,
		SUM((facility_type2 LIKE '%RURAL%')::int) as rural_class_institutions,
		SUM((facility_type2 LIKE '%URBAN%')::int) as urban_class_institutions,
		SUM(pregnancy_beds) as pregnancy_beds,
		SUM(post_pregnancy_beds) as post_pregnancy_beds,
		SUM(newborn_beds) as newborn_beds,
		SUM(labor_rooms) as labor_rooms,
		SUM(ultrasound_systems) as ultrasound_systems,
		SUM(doctors) as doctors,
		SUM(family_physicians) as family_physicians,
		SUM(gynecologists) as gynecologists,
		SUM(nurses) as nurses
	FROM clues_data
	GROUP BY locality
) as clues_data
USING(locality)
