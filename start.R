library(plumber)
library(promises)
library(future)
plan(multisession)
pr("plumber.R") %>%
  pr_run(port=8080)