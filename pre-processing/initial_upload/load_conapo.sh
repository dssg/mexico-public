#!/bin/sh

#  load_conapo.sh
#  
#
#  Created by Julius Adebayo on 7/3/14.
#

HOST=
USER=
DB=mexico
export PGPASSWORD=""
TBLFILE='/Users/julius/Desktop/projects/dssg/mexico_personal/CONAPO/Sociodemographicvariables.csv'

psql -h $HOST -U $USER $DB <<EOFILE

DROP SCHEMA conapo CASCADE;
CREATE SCHEMA IF NOT EXISTS conapo;

CREATE TABLE conapo.sociodemographicvariables (
case_id integer,
year integer,
state varchar,
state_id integer,
state_id_inegi integer,
population decimal,
population_male decimal,
population_female decimal,
births decimal,
deaths decimal,
emigration_international decimal,
immigration_international decimal,
emigration_domestic decimal,
immigration_domestic decimal,
natural_growth decimal,
migration_growth decimal,
total_growth decimal,
life_expectancy_male decimal,
life_expectancy_female decimal,
life_expectancy decimal,
migration_domestic_net decimal,
migration_international_net decimal,
infant_mortality_rate_male decimal,
infant_mortality_rate_female decimal,
infant_mortality_rate decimal,
mortality_rate decimal,
birth_rate decimal,
natural_growth_rate decimal,
social_growth_rate decimal,
growth_rate decimal,
emigration_domestic_rate decimal,
immigration_domestic_rate decimal,
migration_domestic_rate decimal,
migration_international_rate decimal,
fertility_rate decimal

)
;
\copy conapo.sociodemographicvariables from $TBLFILE with CSV HEADER encoding 'ISO_8859_5';

ALTER TABLE conapo.sociodemographicvariables
ALTER COLUMN state_id type varchar using state_id::varchar;

UPDATE conapo.sociodemographicvariables
SET state_id = CONCAT(CASE WHEN state_id::int < 10 THEN '0' ELSE '' END, state_id);

EOFILE
