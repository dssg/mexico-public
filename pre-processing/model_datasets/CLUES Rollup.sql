SELECT COUNT(*) as clues_locations,
	SUM(pregnancy_beds) as pregnancy_beds,
	SUM(post_pregnancy_beds) as post_pregnancy_beds,
	SUM(newborn_beds) as newborn_beds,
	SUM(labor_rooms) as labor_rooms,
	SUM(ultrasound_systems) as ultrasound_systems,
	SUM(doctors) as doctors,
	SUM(family_physicians) as family_physicians,
	SUM(gynecologists) as gynecologists,
	SUM(nurses) as nurses,
	state_muni_code,
	institution_type,
	facility_class1,
	facility_class2
FROM (
	SELECT *,
		CONCAT(state_code, municipality_code) as state_muni_code,
		CASE 
			WHEN institution_key IN('CRUZ ROJA', 'DIF', 'PEMEX', 'SCT', 'SEDENA', 'SEMAR', 'UNIVERSITARIO') THEN 'other'
			WHEN institution_key IN('IMSS', 'ISSSTE') THEN 'IMSS-ISSSTE'
			WHEN institution_key IN('ESTATAL', 'MUNICIPAL') THEN 'ESTATAL-MUNICIPAL'
			ELSE institution_key
		END AS institution_type,
		--CASE
		--	WHEN facility_status = 'EN OPERACIÓN' THEN 'in_operation'
		--	WHEN facility_status = 'FUERA DE OPERACIÓN (TOTAL O PARCIAL)' THEN 'partial_no_operation'
		--	WHEN facility_status = 'OBRA EN PROCESO O PENDIENTE DE ENTRAR EN OPERACIÓN' THEN 'in_progress'
		--END AS facility_status,
		CASE
			WHEN facility_type2 LIKE '%RURAL%' THEN 'rural'
			WHEN facility_type2 LIKE '%URBANO%' THEN 'urban'
			ELSE 'other'
		END AS facility_class1,
		CASE
			WHEN facility_type2 = 'RURAL DE 01 NÚCLEO BÁSICO' THEN 'ruralA'
			WHEN facility_type2 = 'RURAL DE 02 NÚCLEOS BÁSICOS' THEN 'ruralB'
			WHEN facility_type2 = 'RURAL DE 03 NÚCLEOS BÁSICOS Y MÁS' THEN 'ruralC'
			WHEN facility_type2 IN('URBANO DE 01 NÚCLEOS BÁSICOS', 'URBANO DE 02 NÚCLEOS BÁSICOS', 'URBANO DE 03 NÚCLEOS BÁSICOS', 'URBANO DE 04 NÚCLEOS BÁSICOS') THEN 'urbanA'
			WHEN facility_type2 IN('URBANO DE 05 NÚCLEOS BÁSICOS', 'URBANO DE 06 NÚCLEOS BÁSICOS', 'URBANO DE 07 NÚCLEOS BÁSICOS', 'URBANO DE 08 NÚCLEOS BÁSICOS') THEN 'urbanB'
			WHEN facility_type2 IN('URBANO DE 09 NÚCLEOS BÁSICOS', 'URBANO DE 10 NÚCLEOS BÁSICOS', 'URBANO DE 11 NÚCLEOS BÁSICOS', 'URBANO DE 12 NÚCLEOS BÁSICOS Y MÁS') THEN 'urbanC'
			ELSE 'other'
		END AS facility_class2
	FROM clues_data
) AS altered_clues
GROUP BY state_muni_code, institution_type, facility_class1, facility_class2
