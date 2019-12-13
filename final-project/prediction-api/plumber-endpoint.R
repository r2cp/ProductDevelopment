# Este archivo corresponde a la creación del endpoint
library(plumber)

# Specifying keys for the S3 as environment variables
Sys.setenv("AWS_ACCESS_KEY_ID" = "ASIAYHETA5L64LMOCQXY",
           "AWS_SECRET_ACCESS_KEY" = "6pE+Rc6JBzTE7i7cG0N2jEOEFvJ58J/RT99uIB5m", 
           "AWS_DEFAULT_REGION" = "us-east-1", 
           "AWS_SESSION_TOKEN" = "FwoGZXIvYXdzEN3//////////wEaDKWnBlQ5FAwPxmSf/SLDAS4s06CmRuQpVgqx7IczNZ/Oro29g9nGc97Qxm/NrNQZrzWkORrUoVphrVeR89XxfUvkNDEo7r7Qz0PYtpHWNWNlHsI5O5E50uVPbB6CPswgn42aQ2E009Fq6DwdM2L/i0Skmg6tfTUnX9qBawwTen1Zy1DsyQ7xmERf2KvfsssPHjPtJwrLtVLBlyLkLrmH4Lua6mLDKmuJeiylB2G+qU8q9S1YT7xjRRgTtJKgJ7++CFr8jQhaXb1BIs2pR1D+L1XEqyjMiMzvBTItUKEIJoXFadM8ZrQFt5JR/ZINnLg3+z2E6ZlWji8msdWKH1XN3GD9ubDvSAwB"
)

# Set the bucket name to dump the log files
Sys.setenv("API_BUCKET_NAME" = "pd-final-project")

# Load the prediction API at port 8888 
r <- plumb('prediction-api.R')
r$run(host = "0.0.0.0", port = 8888)
