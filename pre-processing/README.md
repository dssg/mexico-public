The three folders in this directory should be run in the following order:

1. initial_upload
2. data_cleaning
3. model_datasets

Initial_upload uploads the database files to PostGRES. Data cleaning then munges them a bit and translates them. Model_datasets then creates the final datasets upon which we did most of our modeling and a bit of our analysis.

The order of which those scripts are run within those folders should not matter, with the exception of model_datasets. In model_datasets all_muni_joins.sql and municipality.sql should be the last ones run. The other scripts in that folder generate intermediate tables which are used at the end by those scripts to generate our final model datasets.

Within the data_cleaning folder there is a "misc" folder that just contains a bunch of random scripts that helped us make sense of the data. They are't necessary to run but are just helpful for reference.
