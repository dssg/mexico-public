SELECT COALESCE(nacim02, nacim03, nacim04, nacim05, nacim06, nacim07) as field_name,
	*
FROM (
	SELECT column_name as nacim02
	FROM information_schema.columns
	WHERE table_schema = 'nac_births'
	AND table_name = 'nacim02'
	) as table2
FULL OUTER JOIN (
	SELECT column_name as nacim03
	FROM information_schema.columns
	WHERE table_schema = 'nac_births'
	AND table_name = 'nacim03'
	) as table3
ON table2.nacim02 = table3.nacim03
FULL OUTER JOIN (
	SELECT column_name as nacim04
	FROM information_schema.columns
	WHERE table_schema = 'nac_births'
	AND table_name = 'nacim04'
	) as table4
ON table3.nacim03 = table4.nacim04
FULL OUTER JOIN (
	SELECT column_name as nacim05
	FROM information_schema.columns
	WHERE table_schema = 'nac_births'
	AND table_name = 'nacim05'
	) as table5
ON table4.nacim04 = table5.nacim05
FULL OUTER JOIN (
	SELECT column_name as nacim06
	FROM information_schema.columns
	WHERE table_schema = 'nac_births'
	AND table_name = 'nacim06'
	) as table6
ON table5.nacim05 = table6.nacim06
FULL OUTER JOIN (
	SELECT column_name as nacim07
	FROM information_schema.columns
	WHERE table_schema = 'nac_births'
	AND table_name = 'nacim07'
	) as table7
ON table6.nacim06 = table7.nacim07
ORDER BY nacim02