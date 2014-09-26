DROP TABLE IF EXISTS maternal_mortality_data;
CREATE TABLE maternal_mortality_data AS
SELECT
	CASE WHEN anionac = 0 THEN NULL ELSE anionac::int END as dob_year,
	CASE WHEN mesnac = 0 THEN NULL ELSE mesnac::int END as dob_month,
	CASE WHEN dianac = 0 THEN NULL ELSE dianac::int END as dob_day,
	CASE
		WHEN anionac = 0 OR mesnac = 0 OR dianac = 0 THEN NULL
		ELSE to_date(anionac || '/' || mesnac || '/' || dianac, 'YYYY/MM/DD')
	END as date_of_birth,
	sexo::int as sex,
	edaduni as age_code,
	CASE 
		WHEN edadvalor::int = 998 THEN NULL edadvalor::int 
		ELSE edadvalor::int
	END as age_number,
	nacion::int as nationality,
	edo_civil::int as civil_status,
	concat(CASE WHEN entrh < 10 THEN '0' ELSE '' END, entrh) as residence_state,
	concat(CASE 
				WHEN munrh < 10 THEN '00'
				WHEN munrh < 100 THEN '0'
				ELSE ''
				END, munrh) as residence_municipality,
	concat(CASE 
				WHEN locrh < 10 THEN '000'
				WHEN locrh < 100 THEN '00'
				WHEN locrh < 1000 THEN '0'
				ELSE '' 
				END, locrh) as residence_locality,
	tamlocrh::int as residence_locality_size,
	ocupacion::int as occupation,
	escolar::int as education,
	derech::int as insurance_coverage,
	concat(CASE WHEN entocu < 10 THEN '0' ELSE '' END, entocu) as death_state,
	concat(CASE 
				WHEN munocu < 10 THEN '00'
				WHEN munocu < 100 THEN '0'
				ELSE ''
				END, munocu) as death_municipality,
	concat(CASE 
				WHEN lococu < 10 THEN '000'
				WHEN lococu < 100 THEN '00'
				WHEN lococu < 1000 THEN '0'
				ELSE '' 
				END, lococu) as death_locality,
	tamlococ::int as death_locality_size,
	sitio_def::int as death_place,
	CASE WHEN aniodef = 0 THEN NULL ELSE aniodef::int END as dod_year,
	CASE WHEN mesdef = 0 THEN NULL ELSE mesdef::int END as dod_month,
	CASE WHEN diadef = 0 THEN NULL ELSE diadef::int END as dod_day,
	CASE
		WHEN aniodef = 0 OR mesdef = 0 OR diadef = 0 THEN NULL
		ELSE to_date(aniodef || '/' || mesdef || '/' || diadef, 'YYYY/MM/DD')
	END as date_of_death,	
	CASE WHEN horadef = 99 THEN NULL ELSE horadef::int END as dod_hour,
	CASE WHEN mindef = 99 THEN NULL ELSE mindef::int END as dod_minute,
	asist::int as medical_assistance,
	causa4 as icd_10_4,
	substring(causa3, 1, 3) as icd_10_3,
	presunto::int as alleged,
	trabajo::int as occurred_during_work,
	lugles::int as unknown_lugles,
	violfam::int as family_violence,
	necropcia::int as autopsy,
	certific::int as certifying_person,
	concat(CASE WHEN entregf < 10 THEN '0' ELSE '' END, entregf) as registration_state,
	concat(CASE 
				WHEN munregf < 10 THEN '00'
				WHEN munregf < 100 THEN '0'
				ELSE ''
				END, munregf) as registration_municipality,
	CASE WHEN anioreg = 0 THEN NULL ELSE anioreg::int END as registration_year,
	CASE WHEN mesreg = 0 THEN NULL ELSE mesreg::int END as registration_month,
	CASE WHEN diareg = 0 THEN NULL ELSE diareg::int END as registration_day,
	peso::int as weight,
	CASE WHEN aniocert = 0 THEN NULL ELSE aniocert::int END as certification_year,
	CASE WHEN mescert = 0 THEN NULL ELSE mescert::int END as certification_month,
	CASE WHEN diacert = 0 THEN NULL ELSE diacert::int END as certification_day,
	condemba::int as pregnancy_condition,
	rel_emba::int as pregnancy_complications,
	complicaro::int as caused_by_preg_compls,
	year::int as year_of_db,
	rmm::int as maternal_mortality_reason
FROM maternal_mortality.maternal_mortality
;

ALTER TABLE maternal_mortality_data 
ADD COLUMN primary_key SERIAL PRIMARY KEY
;

CREATE INDEX mm_mother_res_idx on maternal_mortality_data (residence_state, residence_municipality, residence_locality);
CREATE INDEX mm_mother_death_idx on maternal_mortality_data (death_state, death_municipality, death_locality);
