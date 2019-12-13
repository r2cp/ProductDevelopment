# Este archivo corresponde a la creación del endpoint
library(plumber)

# Specifying keys for the S3 as environment variables
Sys.setenv("AWS_ACCESS_KEY_ID" = "ASIAYHETA5L6Q3TBY2AW",
           "AWS_SECRET_ACCESS_KEY" = "zSGzlbmkpiN6Fl2+F5Rp+BIoBmXUUZNRs0Ieat6y", 
           "AWS_DEFAULT_REGION" = "us-east-1", 
           "AWS_SESSION_TOKEN" = "FwoGZXIvYXdzENb//////////wEaDEhv3M4Lnvt101vz1iLDAXsTmTn53pCPAfAGzB7affELsO83HZJ3xsvxJT1prUIUcd1yep+SqJhHTdWf5iF3Ofd5NIRE07LSekPtzUtG4HK0i5Z6CB857btGOKAV4WMkIVqg5h5r0Bd24Ld4H7A6W0lf7zduo5coqcv2A9ksYnOqb9I3AuzZkLdeyltNUbynjWAS3ufruTgez5mAd0cpvDi+eMUOT3DnFoRyoOcpylNOcJvyC9SJqHMo5AES2TwmBij/Nbng+Z0oud/adWQYEWvAXSi6wcrvBTItDbvFQKgxBNOEoYpk4OUhTZ8y5srSxhJxcP7j0v2SKXRCNg4QbH/2E/PaCckV")

# Set the bucket name to dump the log files
Sys.setenv("API_BUCKET_NAME" = "pd-final-project")

# Load the prediction API at port 8888 
r <- plumb('prediction-api.R')
r$run(host = "0.0.0.0", port = 8888)
