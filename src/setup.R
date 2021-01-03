required_packages <- c(
    "vroom",
    "LaF",
    "dplyr",
    "fs",
    "DataExplorer",
    "janitor",
    "jsonlite",
    "dplyr",
    "future",
    "promises",
    "plumber",
    "R6",
    "rmarkdown",
    "stringr"
)

options(warn=2) # cause the build to fail if any packages fail to install
install.packages(required_packages)