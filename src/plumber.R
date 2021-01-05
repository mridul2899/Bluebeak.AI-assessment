source("function_r6.R")

#* Upload and analyze the uploaded data
#* @param project Directory for the files to go into
#* @param data Path to the file containg data
#* @param name Name for the sub-directories
#* @param description Description for the tags
#* @get /up
upload_data <- function(project="", data="", name="", description="") {
  runnerC(project,
          data,
          name,
          description)
}
