#!/bin/sh

# Define database parameters
HOST=
USER=
DB=mexico
export PGPASSWORD=""
SHPFILE=/Users/Nicke/desktop/dssg/mexico/data/LocalitiesAndMunicipalities/SHP/LOCALIDADES_GM_10.shp

# Create local_muni schema and drop existing tables
psql -h $HOST -U $USER $DB <<EOF
DROP TABLE IF EXISTS localities
EOF

# Load data
shp2pgsql -W "latin1" -g geom $SHPFILE localities | psql -h $HOST -U $USER $DB

# Add command to add index once import is successful
psql -h $HOST -U $USER $DB <<EOF
CREATE INDEX "localidades_geom_gist" ON "local_muni"."localidades" USING GIST ("geom");
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext) values ( 99999, 'mexico', 99999, '+proj=lcc +lat_1=17.5 +lat_2=29.5 +lat_0=12 +lon_0=-102 +x_0=2500000 +y_0=0 +ellps=GRS80 +units=m +no_defs', 'PROJCS["North_America_Lambert_Conformal_Conic",GEOGCS["ITRF_1992",DATUM["ITRF_1992",SPHEROID["GRS_1980",6378137.0,298.257222101]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]],PROJECTION["Lambert_Conformal_Conic_2SP"],PARAMETER["False_Easting",2500000.0],PARAMETER["False_Northing",0.0],PARAMETER["Central_Meridian",-102.0],PARAMETER["Standard_Parallel_1",17.5],PARAMETER["Standard_Parallel_2",29.5],PARAMETER["Latitude_Of_Origin",12.0],UNIT["Meter",1.0]]');
SELECT UpdateGeometrySRID('localities','geom',99999);
EOF
