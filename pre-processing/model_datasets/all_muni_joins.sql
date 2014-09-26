DROP TABLE IF EXISTS nick.all_municipality_model_data;
CREATE TABLE nick.all_municipality_model_data AS
WITH yearly AS (
	SELECT * FROM 
	(SELECT
	    count(*) as deaths,
	    dod_year as year,
	    concat(residence_state, residence_municipality) as municipality
	FROM maternal_mortality_data
	GROUP BY municipality, year
	) AS deaths_data
	FULL OUTER JOIN(
		SELECT  *
		FROM layla.aggregated_births_muni_level
	) as births_aggregate
	USING(municipality, year)
	FULL OUTER JOIN(
		SELECT  concat(state_id, muni_id) as municipality,
			*
		FROM stats.distances
	) as distances_aggregate
	USING(municipality, year)
)
SELECT *
FROM(
	SELECT cvegeo as municipality, nom_ent, nom_mun,
	    CASE WHEN pob1 >= 0 THEN pob1 ELSE NULL END as pop_total,
	    CASE WHEN pob42 >= 0 THEN pob42 ELSE NULL END as pop_birth,
	    CASE WHEN pob31 >= 0 THEN pob31 ELSE NULL END as pop_fem,
	    substring(cvegeo, 1, 2) as ent
	FROM census.national_municipal
) as municipalities_census
FULL OUTER JOIN(
	SELECT  cve_mun as municipality,
        	count(*) as n_localities,
	        sum(pob_tot) as pob_tot,
	        sum(vpha) as occupied_dwellings,
	        sum(ana_10*pob_tot)/sum(pob_tot) as no_read,
	        sum(snprim10*pob_tot)/sum(pob_tot) as no_ed,
	        sum(snexc10*pob_tot)/sum(pob_tot) as no_toilet,
	        sum(snee10*pob_tot)/sum(pob_tot) as no_electricity,
	        sum(sague10*pob_tot)/sum(pob_tot) as no_water,
	        sum(prom_oc10*pob_tot)/sum(pob_tot) as people_per_room,
	        sum(pisoter10*pob_tot)/sum(pob_tot) as dirt_floor,
	        sum(snref10*pob_tot)/sum(pob_tot) as no_fridge,
	        sum(im_2010*pob_tot)/sum(pob_tot) as margination,
		sum(((con_ubic=0)::int)*pob_tot) as urban_pop,
		sum(((con_ubic>0)::int)*pob_tot) as rural_pop,
		sum(((con_ubic=1)::int)*pob_tot) as rural1_pop,
		sum(((con_ubic=2)::int)*pob_tot) as rural2_pop,
		sum(((con_ubic=3)::int)*pob_tot) as rural3_pop,
		sum(((con_ubic=4)::int)*pob_tot) as rural4_pop,		
		sum((con_ubic=0)::int) as urban_localities,
		sum((con_ubic>0)::int) as rural_localities
	FROM localities 
	GROUP BY municipality
) as municipalities_info
USING(municipality)
FULL OUTER JOIN(
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
	ON CONCAT(clues_data.state_code, clues_data.municipality_code, clues_data.locality_code) = localities.cve_loc
	GROUP BY municipality
) as clues_data
USING(municipality)
FULL OUTER JOIN(
	SELECT cvegeo as municipality, *
	FROM julius.complete_municipality_socioeconomic_factors
) as census_data
USING(municipality)
FULL OUTER JOIN yearly USING (municipality);
