# include packages
suppressPackageStartupMessages({
  library("future")
  library(R6)
})

plan(multisession) # for parallelism

# R6 Class for storing states and running functions
RunnerC <- R6Class("RunnerC",
  public = list(
    root_dir = NULL,
    sub_dir = NULL,
    file_path = NULL,

    initialize = function(project, name, data) {
      # include packages
      suppressPackageStartupMessages({
        library(vroom)
        library(dplyr)
        library(fs)
        library(DataExplorer)
        library(janitor)
        library(jsonlite)
        library(LaF)
      })

      # assign paths for directories
      self$root_dir <- project
      self$sub_dir <- paste(project, name, sep="/")

      # create the directories
      private$create_directories()

      # copy the file containing data into the path and store file path
      self$file_path <- file_copy(data, new_path=self$sub_dir, overwrite=TRUE)
    },

    create_tibble = function() {
      # approximate 5 percent of number of rows in the file
      n_rows <- (
        laf_open_csv(self$file_path,
                     column_types=c("integer", "double", "character")) %>%
          nrow() * 0.05 %>%
        round()
      )

      # create a tibble containing only 5 percent rows
      private$tibble <- vroom(
        self$file_path,
        guess_max=n_rows,
        .name_repair = ~ make_clean_names(., case="all_caps")
      )
    },

    # function to create preview of file contents
    generate_preview = function(filename) {
      preview_path <- paste(self$sub_dir, filename, sep="/")
      preview_tibble <- vroom(self$file_path, n_max=100)
      write_json(preview_tibble, path=preview_path)
    },

    # function to describe fields in the file
    describe_basic = function(filename) {
      intro_path <- paste(self$sub_dir, filename, sep="/")
      intro <- introduce(private$tibble)
      write_json(intro, path=intro_path)
    },

    # function to analyze missing fields in the profile
    analyze_missing = function(filename) {
      miss_path <- paste(self$sub_dir, filename, sep="/")
      miss <- profile_missing(private$tibble)
      write_json(miss, path=miss_path)
    },

    # function to generate the list of files in the root directory
    generate_list = function(filename, description) {
      list_path <- paste(self$root_dir, filename, sep="/")
      file_list <- dir_info(self$root_dir, recurse=FALSE)
      write_json({
          mutate(file_list, description) %>%
            rename(project_data=path) %>%
            select(project_data, user, size, description, modification_time)
        },
        path=list_path
      )
    }
  ),

  private = list(
    tibble = NULL,

    # function to create directories
    create_directories = function() {
      # if root directory doesn't exist, make it
      if (!dir.exists(self$root_dir)) {
        dir_create(self$root_dir, recurse=T, mode="u=rwx,go=rx")
      }

      # if the subdirectory doesn't exist, make it
      if (!dir.exists(self$sub_dir)) {
        dir_create(self$sub_dir)
      }
    }
  )
)

# function to initiate instance and run methods
runnerC <- function(project, data, name, description) {
  future({
    # create an instance of RunnerC class
    run <- RunnerC$new(project, name, data)

    # load the tibble from data file and store that as private state
    run$create_tibble()

    # generate files from the data
    run$generate_preview("preview.json")
    run$describe_basic("intro.json")
    run$analyze_missing("miss.json")
    run$generate_list("list.json", description)
  }) %plan% multisession
}