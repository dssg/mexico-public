### Documentation
# This script imports the script "model_municipalities.R" which contains a function that generates an output of various models on a dataset
# Once the function in "model_municipalities.R" is imported, this function loops through a bunch of variations of that function by calling the function multiple times and passing different parameters to it
# The first few lines of this file needs to be changed depending on the environment. They define 1) the location of "model_municipalities.R", 2) the output directory, and 3) the location of the file "model_iteration_output.Rmd" which supports "model_municipalities.R"

source("/Users/Nicke/Desktop/DSSG/mexico/nick/model_municipalities.R")
main_output_dir <- "/Users/Nicke/Desktop/mexico_model_outputs"
rmd_dir <- "/Users/Nicke/Desktop/DSSG/mexico/nick"

### Loop Execution
runLoop <- function(subsetData_values, varRemove_values, getIndeps_values, getDeps_values, getWeights_values, nfolds_values, alpha_values, seed_set_values){
  dir.create(main_output_dir, showWarnings = FALSE, recursive=TRUE)
  for(subsetData_method in subsetData_values){
    for(varRemove_method in varRemove_values){
      for(getIndeps_method in getIndeps_values){
        for(getDeps_method in getDeps_values){
          for(getWeights_method in getWeights_values){
            for(nfolds in nfolds_values){
              for(alpha in alpha_values){
                for(seed_set in seed_set_values){
                  #Don't run for interacted indepedent variables and no variable reduction since I'm afraid it's gonna implode
                  if(!(varRemove_method=="none" & getIndeps_method=="interact")){
                    try({
                      log_message <- paste(Sys.time(), "Running", subsetData_method, varRemove_method, getIndeps_method, getDeps_method, getWeights_method, nfolds, alpha, seed_set)
                      log_message_file <- file(file.path(main_output_dir, "log_message_file.txt"), open="a")
                      write(log_message, log_message_file)
                      close(log_message_file)
                    })
                    try({
                      runModels(main_output_dir, subsetData_method, varRemove_method, getIndeps_method, getDeps_method, getWeights_method, nfolds, alpha, seed_set)
                    })
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

### Test Loop
# subsetData_values <- "all"
# varRemove_values <- "auto"
# getIndeps_values <- "interact"
# getDeps_values <- "mmr"
# getWeights_values <- "popBirth"
# nfolds_values <- 10
# alpha_values <- .5
# seed_set_values <- TRUE
# runLoop(subsetData_values, varRemove_values, getIndeps_values, getDeps_values, getWeights_values, nfolds_values, alpha_values, seed_set_values)

### Important Loop Variations
subsetData_values1 <- c("all", "no0", "popThresh")
varRemove_values1 <- c("auto", "none")
getIndeps_values1 <- "reg"
getDeps_values1 <- "mmr"
getWeights_values1 <- "popBirth"
nfolds_values1 <- 10
alpha_values1 <- .5
seed_set_values1 <- TRUE
runLoop(subsetData_values1, varRemove_values1, getIndeps_values1, getDeps_values1, getWeights_values1, nfolds_values1, alpha_values1, seed_set_values1)

# subsetData_values2 <- c("all", "no0", "popThresh")
# varRemove_values2 <- c("auto", "none")
# getIndeps_values2 <- "reg"
# getDeps_values2 <- "mmrThresh"
# getWeights_values2 <- "none"
# nfolds_values2 <- 10
# alpha_values2 <- .5
# seed_set_values2 <- TRUE
# runLoop(subsetData_values2, varRemove_values2, getIndeps_values2, getDeps_values2, getWeights_values2, nfolds_values2, alpha_values2, seed_set_values2)

# subsetData_values3 <- c("all", "popThresh")
# varRemove_values3 <- "auto"
# getIndeps_values3 <- "interact"
# getDeps_values3 <- "mmr"
# getWeights_values3 <- "popBirth"
# nfolds_values3 <- 10
# alpha_values3 <- .5
# seed_set_values3 <- TRUE
# runLoop(subsetData_values3, varRemove_values3, getIndeps_values3, getDeps_values3, getWeights_values3, nfolds_values3, alpha_values3, seed_set_values3)

### Full Loop Values
# subsetData_values <- c("all", "no0", "no1", "popThresh")
# varRemove_values <- c("manual", "auto", "none")
# getIndeps_values <- c("reg", "interact")
# getDeps_values <- c("mmrThresh", "deathsThresh", "mmr")
# getWeights_values <- c("popBirth", "none")
# nfolds_values <- 10
# alpha_values <- .5
# seed_set_values <- TRUE
# runLoop(subsetData_values, varRemove_values, getIndeps_values, getDeps_values, getWeights_values, nfolds_values, alpha_values, seed_set_values)
