# Este archivo corresponde a la creación del endpoint
library(plumber)

# Specifying keys for the S3 as environment variables
Sys.setenv("AWS_ACCESS_KEY_ID" = "AKIAUAWWR46PKEKOIMFV",
           "AWS_SECRET_ACCESS_KEY" = "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", 
           "AWS_DEFAULT_REGION" = "us-east-1", 
           "API_BUCKET_NAME" = "pd-final-project-log",
           "AWS_SESSION_TOKEN" = "")

# Load the prediction API at port 8888 
r <- plumb('prediction-api.R')
r$run(host = "0.0.0.0", port = 8888, swagger = FALSE)

