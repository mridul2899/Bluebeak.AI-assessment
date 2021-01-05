# Libraries to install
suppressPackageStartupMessages({
  library("future")
  library(R6)
})

plan(multisession)

RunnerC <- R6Class("RunnerC",
  public = list(
    strr = NULL,
    p = NULL,
    t = NULL,
    nr = NULL,
    s = NULL,
    p0 = NULL,
    p1 = NULL,
    p2 = NULL,
    path = NULL,

    initialize = function(project, name) {
      self$strr <- project
      self$p <- paste(project, name, sep="/")
      self$p0 <- paste(self$p, "preview.json", sep="/")
      self$p1 <- paste(self$p, "intro.json", sep="/")
      self$p2 <- paste(self$p, "miss.json", sep="/")
      self$path <- paste(project, "list.json", sep="/")

      suppressPackageStartupMessages({
        library(vroom)
        library(dplyr)
        library(fs)
        library(DataExplorer)
        library(janitor)
        library(jsonlite)
        library(LaF)
      })
    },

    create_directories = function() {
      if (!dir.exists(self$strr)) {
        dir_create(self$strr, recurse=T, mode="u=rwx,go=rx")
      }

      if (!dir.exists(self$p)) {
        dir_create(self$p)
      }
    },

    process_data = function(data) {
      self$t <- file_copy(data, new_path=self$p, overwrite=TRUE)
      open_t <- laf_open_csv(self$t,
                             column_types=c("integer", "double", "character"))
      self$nr <- round(nrow(open_t) * 0.05)
      self$s <- vroom(
        self$t,
        guess_max=self$nr,
        .name_repair = ~ make_clean_names(., case="all_caps")
      )
    },

    write_files = function(description) {
      write_json((vroom(self$t, n_max=100)),
                           path=self$p0)
      write_json((introduce(self$s)),
                           path=self$p1)
      write_json((profile_missing(self$s)),
                           path=self$p2)
      info <- dir_info(self$strr, recurse=FALSE)
      mutated <- mutate(info, description)
      renamed <- rename(mutated, project_data=path)
      write_json(
        select(renamed, project_data, user, size, description, modification_time),
        path=self$path
      )
    }
  )
)

# function start
runnerC <- function(project, data, name, description) {
  future({
    run <- RunnerC$new(project, name)
    run$create_directories()
    run$process_data(data)
    run$write_files(description)
  }) %plan% multisession
}