library(aws.s3)

## Some utility functions

# Show list of buckets
bucketlist()

# Public buckets
get_bucket(bucket = '1000genomes')

# Specifying keys as environment variables
Sys.setenv("AWS_ACCESS_KEY_ID" = "ASIAYHETA5L6Q3TBY2AW",
           "AWS_SECRET_ACCESS_KEY" = "zSGzlbmkpiN6Fl2+F5Rp+BIoBmXUUZNRs0Ieat6y", 
           "AWS_DEFAULT_REGION" = "us-east-1", 
           "AWS_SESSION_TOKEN" = "FwoGZXIvYXdzENb//////////wEaDEhv3M4Lnvt101vz1iLDAXsTmTn53pCPAfAGzB7affELsO83HZJ3xsvxJT1prUIUcd1yep+SqJhHTdWf5iF3Ofd5NIRE07LSekPtzUtG4HK0i5Z6CB857btGOKAV4WMkIVqg5h5r0Bd24Ld4H7A6W0lf7zduo5coqcv2A9ksYnOqb9I3AuzZkLdeyltNUbynjWAS3ufruTgez5mAd0cpvDi+eMUOT3DnFoRyoOcpylNOcJvyC9SJqHMo5AES2TwmBij/Nbng+Z0oud/adWQYEWvAXSi6wcrvBTItDbvFQKgxBNOEoYpk4OUhTZ8y5srSxhJxcP7j0v2SKXRCNg4QbH/2E/PaCckV")

# Get a file from bucket
t <- get_object("notas-ejemplo-docker.txt", bucket = "pd-final-project")


## Save a JSON file and then get it back as df

library(jsonlite)

# Generate some random JSON file
jsoncars <- toJSON(head(mtcars))
write_json(jsoncars, "jsoncars.json")

# Put JSON file in bucket
put_object(file = "jsoncars.json", 
           object = "jsoncars2.json", 
           bucket = "pd-final-project")

# Check for file in bucket
bucket <- get_bucket(bucket = 'pd-final-project')
bucket

# Check for bucket size
length(bucket)

# Get filenames 
bucket[1]$Contents$Key
bucket[2]$Contents$Key


# Read the file from S3
jsonfile <- s3read_using(FUN = read_json, 
                         object = "jsoncars.json", 
                         bucket = "pd-final-project")
# Get the data back as df
jsoncars <- fromJSON(jsonfile[[1]])


## Get the bucket contents as df
bucket.contents <- get_bucket_df(bucket = "pd-final-project")
bucket.contents


