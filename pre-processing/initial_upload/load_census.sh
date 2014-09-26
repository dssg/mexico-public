#!/bin/sh
# Define database parameters
export HOST=
export USER=
export DB=mexico
export PGPASSWORD=""
export DIRECTORY=/Users/Nicke/desktop/dssg/mexico/data/CensusData/scince2010/shps/national
export SCHEMA="census"

# Create census schema
psql -h $HOST -U $USER $DB -c "CREATE SCHEMA IF NOT EXISTS $SCHEMA;"

for FILE in $(find $DIRECTORY -name "*.shp" -exec basename \{} .shp \;); do
	#drop tables
	psql -h $HOST -U $USER $DB -c "DROP TABLE IF EXISTS $SCHEMA.$FILE;"
	
	# Load data
	shp2pgsql -W "latin1" -g geom "$DIRECTORY/$FILE.shp" "$SCHEMA.$FILE" | psql -h $HOST -U $USER $DB
	
	# Add command to add index once import is successful
	psql -h $HOST -U $USER $DB -c "CREATE INDEX $FILE_ginx ON $SCHEMA.$FILE USING GIST(geom);"
	
done