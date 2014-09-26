DROP TABLE IF EXISTS nick.municipality_model_data;
CREATE TABLE nick.municipality_model_data AS
SELECT
	municipality,
	municipalities_census.nom_ent,
	municipalities_census.nom_mun,
	municipalities_census.pop_total,
	municipalities_census.pop_birth,
	municipalities_census.pop_fem,
	municipalities_census.ent,
	COALESCE(localities_urban_census.urban_pop_birth, 0) as urban_pop_birth,
	COALESCE(localities_urban_census.urban_pop_fem, 0) as urban_pop_fem,
	COALESCE(localities_rural_census.rural_pop_birth, 0) as rural_pop_birth,
	COALESCE(localities_rural_census.rural_pop_fem, 0) as rural_pop_fem,
	municipalities_info.n_localities,
	municipalities_info.pob_tot,
	--municipalities_info.occupied_dwellings, 
	municipalities_info.no_read, 
	municipalities_info.no_ed, 
	municipalities_info.no_toilet, 
	municipalities_info.no_electricity, 
	municipalities_info.no_water, 
	municipalities_info.people_per_room, 
	municipalities_info.dirt_floor, 
	municipalities_info.no_fridge, 
	municipalities_info.margination,
	municipalities_info.urban_pop,
	municipalities_info.rural_pop,
	municipalities_info.rural1_pop,
	municipalities_info.rural2_pop,
	municipalities_info.rural3_pop,
	municipalities_info.rural4_pop,
	municipalities_info.urban_localities,
	municipalities_info.rural_localities,
	COALESCE(deaths_data.deaths, 0) as deaths,
	COALESCE(deaths_data.urban_deaths, 0) as urban_deaths,
	COALESCE(deaths_data.rural_deaths, 0) as rural_deaths,
	COALESCE(clues_data.num_institutions, 0) as num_institutions,
	COALESCE(clues_data.imss_institutions, 0) as imss_institutions,
	COALESCE(clues_data.issste_institutions, 0) as issste_institutions,
	COALESCE(clues_data.ssa_institutions, 0) as ssa_institutions,
	COALESCE(clues_data.opportunidades_institutions, 0) as opportunidades_institutions,
	COALESCE(clues_data.other_institutions, 0) as other_institutions,
	COALESCE(clues_data.rural_institutions, 0) as rural_institutions,
	COALESCE(clues_data.urban_institutions, 0) as urban_institutions,
	COALESCE(clues_data.pregnancy_beds, 0) as pregnancy_beds,
	COALESCE(clues_data.post_pregnancy_beds, 0) as post_pregnancy_beds,
	COALESCE(clues_data.newborn_beds, 0) as newborn_beds,
	COALESCE(clues_data.labor_rooms, 0) as labor_rooms,
	COALESCE(clues_data.ultrasound_systems, 0) as ultrasound_systems,
	COALESCE(clues_data.doctors, 0) as doctors,
	COALESCE(clues_data.family_physicians, 0) as family_physicians,
	COALESCE(clues_data.gynecologists, 0) as gynecologists,
	COALESCE(clues_data.nurses, 0) as nurses,
	census_data.INDI19_R as pct_indig_hhlds,
	census_data.MIG1_R as pct_born_here,
	census_data.RELIG1_R as pct_catholic,
	census_data.RELIG2_R as pct_protestant,
	census_data.RELIG3_R as pct_other_religion,
	census_data.RELIG4_R as pct_non_religion,
	census_data.SALUD1_R as pct_entitled_health_serv,
	census_data.SALUD2_R as pct_no_health_serv,
	census_data.SALUD3_R as pct_IMSS_insured,
	census_data.SALUD4_R as pct_ISSSTE_insured,
	census_data.SALUD5_R as pct_SP_insured,
	census_data.SALUD6_R as pct_other_insured,
	census_data.SCONY1_R as pct_single,
	census_data.HOGAR5_R as pct_hh_fem,
	census_data.HOGAR10_R as pct_hh_u30,
	census_data.HOGAR13_R as pct_hh_30t59,
	census_data.HOGAR19_R as pct_hh_60p,
	census_data.FEC1_R as avg_children_born,
	census_data.FEC2_R as avg_children_born_alive,
	census_data.FEC3_R as pct_15t19_birth,
	census_data.EDU50_R as avg_fem_edu,
	census_data.EDU49_R as avg_edu,
	census_data.EDU40_R as pct_edu_post_basic,
	census_data.EDU37_R as pct_edu_basic,
	census_data.EDU43_R as pct_edu_ms,
	census_data.EDU46_R as pct_edu_hs,
	census_data.EDU25_R as pct_illiterate,
	census_data.ECO1_R as pct_econ_active,
	census_data.ECO10_R as pct_primary_degree,
	census_data.ECO16_R as pct_secondary_degree,
	census_data.ECO19_R as pct_superior_degree,
	census_data.ECO22_R as pct_post_grad,
	census_data.ECO2_R as pct_fem_econ_active,
	census_data.ECO20_R as pct_fem_primary_degree,
	census_data.ECO23_R as pct_fem_post_grad,
	census_data.ECO25_R as pct_unemployed,
	census_data.ECO5_R as pct_fem_employed,
	census_data.ECO7_R as pct_no_school,
	census_data.ECO8_R as pct_fem_no_school,
	census_data.DISC1_R as pct_disabilies,
	census_data.VIV2_R as pct_occupied_dwellings,
	COALESCE(births_aggregate.births, 0) as births,
	COALESCE(births_aggregate.urban_births, 0) as urban_births,
	COALESCE(births_aggregate.rural_births, 0) as rural_births,
	COALESCE(births_aggregate.basico_births, 0) as basico_births,
	COALESCE(births_aggregate.non_basico_births, 0) as non_basico_births,
	COALESCE(births_aggregate.attended_birth_doctor, 0) as attended_birth_doctor,
	COALESCE(births_aggregate.attended_birth_nurse, 0) as attended_birth_nurse,
	COALESCE(births_aggregate.attended_birth_ssa, 0) as attended_birth_ssa,
	COALESCE(births_aggregate.attended_birth_midwife, 0) as attended_birth_midwife,
	COALESCE(births_aggregate.attended_birth_other, 0) as attended_birth_other,
        COALESCE(births_aggregate.attended_birth_unspecified, 0) as attended_birth_unspecified,
	COALESCE(births_aggregate.birth_procedure_normal, 0) as birth_procedure_normal,
	COALESCE(births_aggregate.birth_procedure_cesarean, 0) as birth_procedure_cesarean,
	COALESCE(births_aggregate.birth_procedure_forceps, 0) as birth_procedure_forceps,
	COALESCE(births_aggregate.birth_procedure_other, 0) as birth_procedure_other,
        COALESCE(births_aggregate.birth_procedure_unspecified, 0) as birth_procedure_unspecified,
	COALESCE(births_aggregate.fetus_single, 0) as fetus_single,
	COALESCE(births_aggregate.fetus_twins, 0) as fetus_twins,
	COALESCE(births_aggregate.fetus_three_plus, 0) as fetus_three_plus,
        COALESCE(births_aggregate.fetus_unspecified, 0) as fetus_unspecified,
	COALESCE(births_aggregate.insurance_none, 0) as insurance_none,
	COALESCE(births_aggregate.insurance_imss, 0) as insurance_imss,
	COALESCE(births_aggregate.insurance_issste, 0) as insurance_issste,
	COALESCE(births_aggregate.insurance_sp, 0) as insurance_sp,
	COALESCE(births_aggregate.insurance_opportunidades, 0) as insurance_opportunidades,
	COALESCE(births_aggregate.insurance_other, 0) as insurance_other,
        COALESCE(births_aggregate.insurance_unspecified, 0) as insurance_unspecified,
	--births_aggregate.avg_prenatal_consults as avg_prenatal_consults,
	COALESCE(births_aggregate.pob_ssa, 0) as pob_ssa,
	COALESCE(births_aggregate.pob_opportunidades, 0) as pob_opportunidades,
	COALESCE(births_aggregate.pob_imss, 0) as pob_imss,
	COALESCE(births_aggregate.pob_issste, 0) as pob_issste,
	COALESCE(births_aggregate.pob_other_gov_inst, 0) as pob_other_gov_inst,
	COALESCE(births_aggregate.pob_other_private, 0) as pob_other_private,
	COALESCE(births_aggregate.pob_public_place, 0) as pob_public_place,
	COALESCE(births_aggregate.pob_household, 0) as pob_household,
	COALESCE(births_aggregate.pob_other, 0) as pob_other,
        COALESCE(births_aggregate.pob_unspecified, 0) as pob_unspecified,
	--births_aggregate.avg_mother_pregnancies as avg_mother_pregnancies,
	COALESCE(births_aggregate.prenatal_yes, 0) as prenatal_yes,
	COALESCE(births_aggregate.prenatal_no, 0) as prenatal_no,
        COALESCE(births_aggregate.prenatal_unspecified, 0) as prenatal_unspecified,
	distances_aggregate.clue_distance,
	distances_aggregate.loc_distance,
	distances_aggregate.urban_clue_distance,
	distances_aggregate.rural_clue_distance,
	distances_aggregate.urban_loc_distance,
        distances_aggregate.rural_loc_distance,
	basico_distances.basico_distance,
	basico_distances.urban_basico_distance,
	basico_distances.rural_basico_distance,
        disc10_r, disc11_r, disc12_r, disc13_r, disc14_r, disc1_r, disc2_r, disc3_r, disc4_r, disc5_r, disc6_r, disc7_r, disc8_r, disc9_r, eco10_r, eco11_r, eco12_r, eco13_r, eco14_r, eco15_r, eco16_r, eco17_r, eco18_r, eco19_r, eco1_r, eco20_r, eco21_r, eco22_r, eco23_r, eco24_r, eco25_r, eco26_r, eco27_r, eco28_r, eco29_r, eco2_r, eco30_r, eco31_r, eco32_r, eco33_r, eco34_r, eco35_r, eco36_r, eco37_r, eco38_r, eco39_r, eco3_r, eco40_r, eco41_r, eco42_r, eco43_r, eco44_r, eco45_r, eco4_r, eco5_r, eco6_r, eco7_r, eco8_r, eco9_r, edu10_r, edu11_r, edu12_r, edu13_r, edu14_r, edu15_r, edu16_r, edu17_r, edu18_r, edu19_r, edu1_r, edu20_r, edu21_r, edu22_r, edu23_r, edu24_r, edu25_r, edu26_r, edu27_r, edu28_r, edu29_r, edu2_r, edu30_r, edu31_r, edu32_r, edu33_r, edu34_r, edu35_r, edu36_r, edu37_r, edu38_r, edu39_r, edu3_r, edu40_r, edu41_r, edu42_r, edu43_r, edu44_r, edu45_r, edu46_r, edu47_r, edu48_r, edu49_r, edu4_r, edu50_r, edu51_r, edu5_r, edu6_r, edu7_r, edu8_r, edu9_r, fec1_r, fec2_r, fec3_r, hogar10_r, hogar11_r, hogar12_r, hogar13_r, hogar14_r, hogar15_r, hogar16_r, hogar17_r, hogar18_r, hogar19_r, hogar20_r, hogar21_r, hogar22_r, hogar23_r, hogar24_r, hogar25_r, hogar26_r, hogar2_r, hogar3_r, hogar5_r, hogar6_r, hogar7_r, hogar8_r, hogar9_r, indi10_r, indi11_r, indi12_r, indi13_r, indi14_r, indi15_r, indi16_r, indi17_r, indi18_r, indi19_r, indi1_r, indi20_r, indi2_r, indi3_r, indi4_r, indi5_r, indi6_r, indi7_r, indi8_r, indi9_r, mig10_r, mig11_r, mig12_r, mig13_r, mig14_r, mig15_r, mig16_r, mig1_r, mig2_r, mig3_r, mig4_r, mig5_r, mig6_r, mig7_r, mig8_r, mig9_r, mor1_r, relig1_r, relig2_r, relig3_r, relig4_r, salud1_r, salud2_r, salud3_r, salud4_r, salud5_r, salud6_r, scony10_r, scony11_r, scony12_r, scony1_r, scony2_r, scony3_r, scony4_r, scony5_r, scony6_r, scony7_r, scony8_r, scony9_r, viv10_r, viv11_r, viv12_r, viv13_r, viv14_r, viv15_r, viv16_r, viv17_r, viv18_r, viv19_r, viv20_r, viv21_r, viv22_r, viv23_r, viv24_r, viv25_r, viv26_r, viv27_r, viv28_r, viv29_r, viv2_r, viv30_r, viv31_r, viv32_r, viv33_r, viv34_r, viv35_r, viv36_r, viv37_r, viv38_r, viv39_r, viv3_r, viv40_r, viv41_r, viv4_r, viv5_r, viv6_r, viv7_r, viv8_r, viv9_r,
        family_planning.pct_no_contraceptive,
        family_planning.pct_contraceptive,
        COALESCE(death_rates.general_deaths::decimal, 0::decimal) / municipalities_census.pop_total::decimal * 1000.0 as death_rt,
        death_rates.pct_maternal_deaths,
        md_causes.pct_md_pregnancy,
        md_causes.pct_md_birth,
        md_causes.pct_md_puerperium,
        md_causes.pct_md_b_o10,
        md_causes.pct_md_b_o60,
        md_causes.pct_md_b_o94,
        md_causes.pct_md_b_o30,
        md_causes.pct_md_b_o85,
        md_causes.pct_md_b_o00,
        md_causes.pct_md_b_o20,
        md_causes.pct_md_b_other,
        insurance_mismatch.sp_mismatch,
        insurance_mismatch.opportunidades_mismatch,
        insurance_mismatch.iio_mismatch,
        prenatal_care_municipal.avg_prenatal_consults,
        prenatal_care_municipal.stddev_prenatal_consults,
        prenatal_care_municipal.avg_mother_pregnancies,
        prenatal_care_municipal.stddev_mother_pregnancies,
        COALESCE(prenatal_care_municipal.first_prenatal_tri_no, 0) as first_prenatal_tri_no,
        COALESCE(prenatal_care_municipal.first_prenatal_tri_1, 0) as first_prenatal_tri_1,
        COALESCE(prenatal_care_municipal.first_prenatal_tri_2, 0) as first_prenatal_tri_2,
        COALESCE(prenatal_care_municipal.first_prenatal_tri_3, 0) as first_prenatal_tri_3,
        COALESCE(prenatal_care_municipal.first_prenatal_tri_ignored, 0) as first_prenatal_tri_ignored
	FROM(
	SELECT cvegeo as municipality, nom_ent, nom_mun,
	    CASE WHEN pob1 >= 0 THEN pob1 ELSE NULL END as pop_total,
	    CASE WHEN pob42 >= 0 THEN pob42 ELSE NULL END as pop_birth,
	    CASE WHEN pob31 >= 0 THEN pob31 ELSE NULL END as pop_fem,
	    substring(cvegeo, 1, 2) as ent
	FROM census.national_municipal
) as municipalities_census
FULL OUTER JOIN(
	SELECT  substring(cvegeo, 1, 5) as municipality,
			sum(CASE WHEN pob42 >= 0 THEN pob42 ELSE NULL END) as urban_pop_birth,
			sum(CASE WHEN pob31 >= 0 THEN pob31 ELSE NULL END) as urban_pop_fem
		FROM census.national_loc_urb
		GROUP BY substring(cvegeo, 1, 5)
	) as localities_urban_census
USING(municipality)
FULL OUTER JOIN(
	SELECT  substring(cvegeo, 1, 5) as municipality,
			sum(CASE WHEN pob42 >= 0 THEN pob42 ELSE NULL END) as rural_pop_birth,
			sum(CASE WHEN pob31 >= 0 THEN pob31 ELSE NULL END) as rural_pop_fem
		FROM census.national_loc_rur
		GROUP BY substring(cvegeo, 1, 5)
	) as localities_rural_census
USING(municipality)
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
	SELECT
	    count(*) as deaths,
		sum((l.con_ubic=0)::int) as urban_deaths,
		sum((l.con_ubic>0)::int) as rural_deaths,
	    concat(residence_state, residence_municipality) as municipality
	FROM maternal_mortality_data m JOIN localities l
	ON m.residence_state || m.residence_municipality || m.residence_locality = l.cve_loc
	WHERE m.dod_year >= 2009 AND m.dod_year <= 2012 AND m.pregnancy_condition < 4
	GROUP BY 
	    municipality
) AS deaths_data
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
	SELECT cvegeo as municipality,
            *
	FROM censusdata.national_cpv2010_municipal_caracteristicas_economicas
	FULL OUTER JOIN censusdata.national_cpv2010_municipal_caracteristicas_educativas
	USING(cvegeo)
	FULL OUTER JOIN censusdata.national_cpv2010_municipal_desarrollo_social
	USING(cvegeo)
	FULL OUTER JOIN censusdata.national_cpv2010_municipal_discapacidad
	USING(cvegeo)
	FULL OUTER JOIN censusdata.national_cpv2010_municipal_fecundidad
	USING(cvegeo)
	FULL OUTER JOIN censusdata.national_cpv2010_municipal_hogares_censales
	USING(cvegeo)
	FULL OUTER JOIN censusdata.national_cpv2010_municipal_lengua_indigena
	USING(cvegeo)
	FULL OUTER JOIN censusdata.national_cpv2010_municipal_migracion
	USING(cvegeo)
	FULL OUTER JOIN censusdata.national_cpv2010_municipal_mortalidad
	USING(cvegeo)
	FULL OUTER JOIN censusdata.national_cpv2010_municipal_religion
	USING(cvegeo)
	FULL OUTER JOIN censusdata.national_cpv2010_municipal_servicios_de_salud
	USING(cvegeo)
	FULL OUTER JOIN censusdata.national_cpv2010_municipal_situacion_conyugal
	USING(cvegeo)
	FULL OUTER JOIN censusdata.national_cpv2010_municipal_viviendas
	USING(cvegeo)
) as census_data
USING(municipality)
FULL OUTER JOIN(
	SELECT  municipality,
		sum(births) as births,
		sum(urban_births) as urban_births,
		sum(rural_births) as rural_births,
		sum(basico_births) as basico_births,
		sum(non_basico_births) as non_basico_births,
		sum(attending_personnel_1) as attended_birth_doctor,
		sum(attending_personnel_2) as attended_birth_nurse,
		sum(attending_personnel_3) as attended_birth_ssa,
		sum(attending_personnel_4) as attended_birth_midwife,
		sum(attending_personnel_8) as attended_birth_other,
                sum(attending_personnel_9) as attended_birth_unspecified,
		sum(birth_procedure_1) as birth_procedure_normal,
		sum(birth_procedure_2) as birth_procedure_cesarean,
		sum(birth_procedure_3) as birth_procedure_forceps,
		sum(birth_procedure_8) as birth_procedure_other,
                sum(birth_procedure_9) as birth_procedure_unspecified,
		sum(single_multiple_fetus_1) as fetus_single,
		sum(single_multiple_fetus_2) as fetus_twins,
		sum(single_multiple_fetus_3) as fetus_three_plus,
                sum(single_multiple_fetus_9) as fetus_unspecified,
		sum(insurance_1) as insurance_none,
		sum(insurance_2) as insurance_imss,
		sum(insurance_3) as insurance_issste,
		sum(insurance_7) as insurance_sp,
		sum(insurance_10) as insurance_opportunidades,
		sum(insurance_4) + sum(insurance_5) + sum(insurance_6) + sum(insurance_8) as insurance_other,
                sum(insurance_88) + sum(insurance_99) as insurance_unspecified,
		avg(average_parental_consultations) as avg_prenatal_consults,
		sum(place_of_birth_1) as pob_ssa,
		sum(place_of_birth_2) as pob_opportunidades,
		sum(place_of_birth_3) as pob_imss,
		sum(place_of_birth_4) as pob_issste,
		sum(place_of_birth_5) + sum(place_of_birth_6) + sum(place_of_birth_7) + sum(place_of_birth_8) as pob_other_gov_inst,
		sum(place_of_birth_10) as pob_other_private,
		sum(place_of_birth_11) as pob_public_place,
		sum(place_of_birth_12) as pob_household,
		sum(place_of_birth_13) as pob_other,
                sum(place_of_birth_99) as pob_unspecified,
		avg(average_mother_pregnancies) as avg_mother_pregnancies,
		sum(parental_care_1) as prenatal_yes,
		sum(parental_care_2) as prenatal_no,
                sum(parental_care_8) + sum(parental_care_9) as prenatal_unspecified
	FROM layla.aggregated_births_muni_level
	WHERE year >= 2009 AND year <= 2012
	GROUP BY municipality
) as births_aggregate
USING(municipality)
FULL OUTER JOIN(
	SELECT  CONCAT(state_id, muni_id) as municipality,
		sum(clue_distance*pob_tot)/sum(pob_tot) as clue_distance,
		sum(loc_distance)/sum(pob_tot) as loc_distance,
		sum(CASE WHEN con_ubic=0 THEN clue_distance*pob_tot ELSE NULL END)/sum(CASE WHEN con_ubic=0 THEN pob_tot ELSE NULL END) as urban_clue_distance,
		sum(CASE WHEN con_ubic>0 THEN clue_distance*pob_tot ELSE NULL END)/sum(CASE WHEN con_ubic>0 THEN pob_tot ELSE NULL END) as rural_clue_distance,
		sum(CASE WHEN con_ubic=0 THEN loc_distance*pob_tot ELSE NULL END)/sum(CASE WHEN con_ubic=0 THEN pob_tot ELSE NULL END) as urban_loc_distance,
		sum(CASE WHEN con_ubic>0 THEN loc_distance*pob_tot ELSE NULL END)/sum(CASE WHEN con_ubic>0 THEN pob_tot ELSE NULL END) as rural_loc_distance
	FROM eric.distances
	LEFT JOIN localities
	ON CONCAT(eric.distances.state_id, eric.distances.muni_id, eric.distances.loc_id) = localities.cve_loc
	WHERE year >= 2009 AND year <= 2012
	GROUP BY municipality
) as distances_aggregate
USING(municipality)
FULL OUTER JOIN(
	select cve_mun as municipality,
    	sum(st_distance*pob_tot)/sum(pob_tot) as basico_distance,
    	sum(CASE WHEN con_ubic=0 THEN st_distance*pob_tot ELSE NULL END)/sum(CASE WHEN con_ubic=0 THEN pob_tot ELSE NULL END) as urban_basico_distance,
    	sum(CASE WHEN con_ubic>0 THEN st_distance*pob_tot ELSE NULL END)/sum(CASE WHEN con_ubic>0 THEN pob_tot ELSE NULL END) as rural_basico_distance
	from eric.basico_distance join localities using (cve_loc) group by cve_mun
) as basico_distances
USING(municipality)
FULL OUTER JOIN(
    SELECT muni_res as municipality,
            SUM((family_plan_type='4')::int)::decimal/SUM((family_plan_type IS NOT NULL)::int)::decimal*100.0 as pct_no_contraceptive,
            SUM((family_plan_type!='4' AND family_plan_type IS NOT NULL)::int)::decimal/SUM((family_plan_type IS NOT NULL)::int)::decimal*100.0 as pct_contraceptive
        FROM layla.saeh_model_10_13
        GROUP BY municipality
) as family_planning
USING(municipality)
FULL OUTER JOIN(
    SELECT municipality,
        SUM(maternal_deaths)::decimal / SUM(general_deaths)::decimal * 100.0 as pct_maternal_deaths,
        SUM(general_deaths) as general_deaths
    FROM(
        SELECT concat(entrh, munrh) as municipality,
                count(*) as general_deaths,
                SUM((condemba::int<4)::int) as maternal_deaths
        FROM general_deaths.def2009
        GROUP BY municipality
        UNION ALL
        SELECT concat(entrh, munrh) as municipality,
                count(*) as general_deaths,
                SUM((condemba::int<4)::int) as maternal_deaths
        FROM general_deaths.def2010
        GROUP BY municipality
        UNION ALL
        SELECT concat(entrh, munrh) as municipality,
                count(*) as general_deaths,
                SUM((condemba::int<4)::int) as maternal_deaths
        FROM general_deaths.def2011
        GROUP BY municipality
        UNION ALL
        SELECT concat(concat(CASE WHEN ent_resid::int < 10 THEN '0' ELSE '' END, ent_resid), concat(CASE WHEN mun_resid::int < 10 THEN '00' WHEN mun_resid::int < 100 THEN '0' ELSE '' END, mun_resid)) as municipality,
                --concat(CASE WHEN ent_resid::int < 10 THEN '0' ELSE '' END, ent_resid) as ent_resid,
                --concat(CASE WHEN mun_resid::int < 10 THEN '00' WHEN mun_resid::int < 100 THEN '0' ELSE '' END, mun_resid) as mun_resid,
                count(*) as general_deaths,
                SUM((embarazo::int<4)::int) as pct_maternal_deaths
        FROM general_deaths.def2012defun12
        GROUP BY municipality --ent_resid, mun_resid
    ) as temp_table
    GROUP BY municipality
) as death_rates
USING(municipality)
FULL OUTER JOIN(
    SELECT
        concat(residence_state, residence_municipality) as municipality,
        SUM((pregnancy_condition=1)::int)::decimal/count(*) * 100.0 as pct_md_pregnancy,
        SUM((pregnancy_condition=2)::int)::decimal/count(*) * 100.0 as pct_md_birth,
        SUM((pregnancy_condition=3)::int)::decimal/count(*) * 100.0 as pct_md_puerperium,
        SUM((icd10_3.block_start='O10')::int)::decimal/count(*) * 100.0 as pct_md_b_o10,
        SUM((icd10_3.block_start='O60')::int)::decimal/count(*) * 100.0 as pct_md_b_o60,
        SUM((icd10_3.block_start='O94')::int)::decimal/count(*) * 100.0 as pct_md_b_o94,
        SUM((icd10_3.block_start='O30')::int)::decimal/count(*) * 100.0 as pct_md_b_o30,
        SUM((icd10_3.block_start='O85')::int)::decimal/count(*) * 100.0 as pct_md_b_o85,
        SUM((icd10_3.block_start='O00')::int)::decimal/count(*) * 100.0 as pct_md_b_o00,
        SUM((icd10_3.block_start='O20')::int)::decimal/count(*) * 100.0 as pct_md_b_o20,
        SUM((icd10_3.block_start NOT IN('O10', 'O60', 'O94', 'O30', 'O85', 'O00', 'O20'))::int)::decimal/count(*) * 100.0 as pct_md_b_other
    FROM maternal_mortality_data
    LEFT JOIN icd10_3
    USING (icd_10_3)
    LEFT JOIN icd10_4
    USING (icd_10_4)
    WHERE dod_year >= 2009 AND dod_year <= 2012 AND pregnancy_condition < 4
    GROUP BY 
        municipality
) as md_causes
USING(municipality)
FULL OUTER JOIN(
    SELECT municipality,
	CASE WHEN SUM((mother_health_affiliation = 'sp')::int) != 0 THEN
    	    SUM((mother_health_affiliation = 'sp' AND mother_health_affiliation!=place_of_birth)::int)::decimal / SUM((mother_health_affiliation = 'sp')::int)::decimal * 100.0 
    	    ELSE NULL
        END AS sp_mismatch,
        CASE WHEN SUM((mother_health_affiliation = 'oportunidades')::int) != 0 THEN
    	    SUM((mother_health_affiliation = 'oportunidades' AND mother_health_affiliation!=place_of_birth)::int)::decimal / SUM((mother_health_affiliation = 'oportunidades')::int)::decimal * 100.0
    	    ELSE NULL
        END AS opportunidades_mismatch,
        CASE WHEN SUM((mother_health_affiliation IN('imss', 'issste', 'other'))::int) != 0 THEN
	        SUM((mother_health_affiliation IN('imss', 'issste', 'other') AND mother_health_affiliation!=place_of_birth)::int)::decimal / SUM((mother_health_affiliation IN('imss', 'issste', 'other'))::int)::decimal * 100.0
		ELSE NULL
	END AS iio_mismatch
FROM nick.insurance_mismatch
WHERE year >= 2009 AND year <= 2012
GROUP BY municipality
) as insurance_mismatch
USING(municipality)
FULL OUTER JOIN(
    SELECT *
    FROM nick.prenatal_care_municipal
) as prenatal_care_municipal
USING(municipality)
;
