CREATE TABLE nick.insurance_mismatch AS
SELECT municipality,
    table_year as year,
    mother_health_affiliation,
    place_of_birth,
    count(*) as births
FROM(
    SELECT concat(mother_res_state::text,mother_res_muni) as municipality,
        CASE
	    WHEN mother_health_affiliation = 1 THEN 'none'
	    WHEN mother_health_affiliation = 2 THEN 'imss'
	    WHEN mother_health_affiliation = 3 THEN 'issste'
	    WHEN mother_health_affiliation IN(4, 5, 6, 8) THEN 'other'
	    WHEN mother_health_affiliation = 7 THEN 'sp'
	    WHEN mother_health_affiliation = 10 THEN 'oportunidades'
	    WHEN mother_health_affiliation = 99 THEN 'unspecified'
	END AS mother_health_affiliation,
	CASE
	    WHEN place_of_birth = 1 THEN 'sp'
	    WHEN place_of_birth = 2 THEN 'oportunidades'
	    WHEN place_of_birth = 3 THEN 'imss'
	    WHEN place_of_birth = 4 THEN 'issste'
	    WHEN place_of_birth IN(5, 6, 7, 8, 10, 13) THEN 'other'
	    WHEN place_of_birth IN(11, 12) THEN 'none'
	    WHEN place_of_birth = 99 THEN 'unspecified'
	END as place_of_birth
    FROM public.births_data
) as temp_table
GROUP BY municipality, year, mother_health_affiliation, place_of_birth
