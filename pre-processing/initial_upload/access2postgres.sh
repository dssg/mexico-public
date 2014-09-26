#!/bin/bash

# prompt db password
read -s -p "Password: " password
echo

# loop over files
for file in "$@"
do
  echo "Processing file $file"

  # remove extension
  schema=`basename "$file" .mdb | awk '{gsub(" ", ""); print tolower($0)}'`
  echo $schema

  exists=`PGPASSWORD=$password psql -h  -U -d mexico -t -c "SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = '$schema'"`

  if [ $exists == "1" ]
  then
    echo "Schema $schema exists! Skipping."
  else
		echo "  Creating schema $schema"

		{ echo "CREATE SCHEMA $schema AUTHORIZATION " ; \
			echo "SET SCHEMA '$schema';" ; \
			mdb-schema --no-not-null --no-indexes "$file" postgres \
				| awk '{gsub(/Postgres_Unknown 0x10/,"INTEGER");print;}' ; } \
			| PGPASSWORD=$password psql -h  -U -d mexico

		echo "  Importing tables..."
	  	# loop over tables
	  	tables="$(mdb-tables "$file")"
		for table in $tables
		do
			echo "    $table"
			mdb-export "$file" $table | PGPASSWORD=$password psql -h  -U -d mexico -c "\COPY $schema.\"$table\" FROM STDIN CSV HEADER"
		done
  fi
done
