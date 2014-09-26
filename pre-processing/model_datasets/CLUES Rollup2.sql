SELECT CONCAT(state_code, municipality_code) as municipality,
	count(*) as num_institutions,
	SUM((institution_key IN('IMSS'))::int) as imss_institutions,
	SUM((institution_key IN('ISSSTE'))::int) as issste_institutions,
	SUM((institution_key IN('ESTATAL', 'MUNICIPAL', 'SSA'))::int) as ssa_institutions,
	SUM((institution_key IN('IMSS-OPORTUNIDADES'))::int) as opportunidades_institutions,
	SUM((institution_key IN('CRUZ ROJA', 'DIF', 'PEMEX', 'UNIVERSITARIO', 'PRIVADA', 'SCT', 'SEDENA', 'SEMAR'))::int) as other_institutions,
	SUM((con_ubic=0)::int) as urban_institutions,
	SUM((con_ubic>0)::int) as rural_institutions,
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
LEFT JOIN localities
ON CONCAT(clues_data.state_code, clues_data.municipality_code) = localities.cve_mun
GROUP BY municipality
