CREATE TABLE nick.prenatal_care_municipal AS
SELECT concat(mother_res_state::text,mother_res_muni) as municipality,
	avg(total_parental_consultations) as avg_prenatal_consults,
	stddev(total_parental_consultations) as stddev_prenatal_consults,
	avg(mother_pregnancies) as avg_mother_pregnancies,
	stddev(mother_pregnancies) as stddev_mother_pregnancies,
	SUM((first_parental_trimester=0)::int) AS first_prenatal_tri_no,
	SUM((first_parental_trimester=1)::int) AS first_prenatal_tri_1,
	SUM((first_parental_trimester=2)::int) AS first_prenatal_tri_2,
	SUM((first_parental_trimester=3)::int) AS first_prenatal_tri_3,
	SUM((first_parental_trimester IN(8,9))::int) AS first_prenatal_tri_ignored
FROM births_data
WHERE table_year >= 2009 AND table_year <= 2012
GROUP BY municipality
