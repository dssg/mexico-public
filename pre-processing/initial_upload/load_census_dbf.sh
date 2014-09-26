#!/bin/sh

# Script to load supporting census data files

export HOST=
export USER=
export DB=mexico
export PGPASSWORD=""
export DIRECTORY=/Users/Nicke/desktop/dssg/mexico/data/CensusData/scince2010/shps/national/tablas
export SCHEMA="censusdata"

# Create schema
psql -h $HOST -U $USER $DB -c "CREATE SCHEMA IF NOT EXISTS $SCHEMA;"

# For each dbf file in directory, drop and create tables
for FILE in $(find $DIRECTORY -name "*.dbf" -exec basename \{} .dbf \;); do

	psql -h $HOST -U $USER $DB -c "DROP TABLE IF EXISTS $SCHEMA.$FILE;"

	ogr2ogr -f PostgreSQL \
		PG:"host=$HOST user=$USER dbname=$DB password=$PGPASSWORD" \
		"$DIRECTORY/$FILE.dbf" -nln "$SCHEMA.$FILE" \
	
done