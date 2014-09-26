Files here include:

1. "model_variations.R", "model_municipalities.R", and "model_iteration_output.Rmd" work as a set that runs through a bunch of models and variations for muncipalities. model_variations.R is the "control script" which imports the function in model_municipalities.R and calls it multiple times passing different parameters each time. Model_iteration_output.Rmd is called by model_muncipalities.R and just contains a template for which to output the resulting information
