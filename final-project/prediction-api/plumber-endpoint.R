# Este archivo corresponde a la creación del endpoint
library(plumber)

# Specifying keys for the S3 as environment variables
Sys.setenv("AWS_ACCESS_KEY_ID" = "ASIAYHETA5L6QLSHB35B",
           "AWS_SECRET_ACCESS_KEY" = "4wW06O8VCrCOOyp/5gSA4n8H5LbBXh5vlSQlJCQe", 
           "AWS_DEFAULT_REGION" = "us-east-1", 
           "AWS_SESSION_TOKEN" = "FwoGZXIvYXdzEBgaDFqNBKxttOqSadfG9yLDAU8Hea0/iyeCjke08UFcFEKTYP7yInlEMzVBrdtHc3F0aQjpY4mpEHMAUhYzfUkqr0b92/ANYfkSg8eKGOK0Rla18PcA/FQ9F/5V6ULw7n83i1OoyfEYzhy8cvwvdiRwes47KM1RaN7GEioTsZFwjzLtV9QXtXbJH5dhBcHj67uagcPnIL9JekHlFkAq/1LmSXob9PIlZTSIih4sDH+KvYrefG+31OiQG0Gwxq0XK3vUUzuFiXhTZ4vgT8bf8HuyEqtPPSjbj9nvBTItCPEegGDeGn+/4IQ4sO31W2sKbQWCi3JrVyDfuGi5R9B0KxFG0zhNfKIAtrIa"
)

# Set the bucket name to dump the log files
Sys.setenv("API_BUCKET_NAME" = "pd-final-project")

# Load the prediction API at port 8888 
r <- plumb('prediction-api.R')
r$run(host = "0.0.0.0", port = 8888)
