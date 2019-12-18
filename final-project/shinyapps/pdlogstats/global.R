library(dplyr)
library(jsonlite)
library(aws.s3)
library(tibble)

# Export environment variables for S3 access
# Specifying keys for the S3 as environment variables
Sys.setenv("AWS_ACCESS_KEY_ID" = "AKIAUAWWR46PKEKOIMFV",
           "AWS_SECRET_ACCESS_KEY" = "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", 
           "AWS_DEFAULT_REGION" = "us-east-1", 
           "API_BUCKET_NAME" = "pd-final-project-log",
           "AWS_SESSION_TOKEN" = "")

# Helper function to get model stats from filename in S3 log folder
hlp_getModelStats <- function(filename) {
  # Get the file from the S3 service
  jsonfile <- s3read_using(FUN = read_json, 
                           object = filename, 
                           bucket = Sys.getenv("API_BUCKET_NAME"))
  # Get the log file as a list
  loglist <- fromJSON(jsonfile[[1]])
  
  # Return a tibble with the model stats
  t <- tibble(filename = filename,
              user = loglist$user,
              model = loglist$model, 
              endpoint = loglist$endpoint, 
              req.method = loglist$req.method, 
              remote.addr = loglist$remote.addr, 
              timestamp = loglist$timestamp, 
              payload.size = nrow(loglist$payload))
  
  return(t)
}