Team Mexico: Finding new strategies to reduce maternal mortality
======

## Members
- Julius Adebayo
- Nick Eng
- Eric Potash
- Layla Pournajaf
- Ben Yuhas (Mentor)

## Getting Started
The majority of the startup work will be found in the "pre-processing" directory, primarily in the "initial_upload", "data_cleaning", and "model_datasets" directories.

The three folders should be run in the following order:
initial_upload -> data_cleaning -> model_datasets

The order of which files are run within the "initial_upload" and "data_cleaning" foler most likely does not matter. The only ordering that is important for the "model_datasets" folder is that "all_muni_joins.sql" and "municipality.sql" are run last within the folder.

The three folders solve the following purposes:
- **initial_upload**: uploads the various data files (of varying formats!) into a single Postgres database upon which we can further manipulate
- **data_cleaning**: correctly types variables within tables, cleans up mis-coded/inconsistently-coded data, and translates variable names to English
- **model_datasets**: aggregates data from across the database to generate tables that our models were ultimately built off of, primarily the table created by "municipality.sql"

Once the following 3 folders are run, go ahead and **analyze**!

## Analysis
Our analysis is split into 4 levels of granularity, in order from most granular to least granular, each with their own folder:

1. Individual level
2. Locality level
3. Municipality level
4. State level
5. Country level

Each of those folders contains up to two folders, one for modeling and one for exploratory analysis. Their purposes should be self-explanatory.

## Additional Documentation
Additional documentation can be found in the individual folders. Furthermore data dictionaries can be found in the "data_dicts" folder.
