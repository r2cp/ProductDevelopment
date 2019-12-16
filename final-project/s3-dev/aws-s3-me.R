library(aws.s3)

## Marco's data
#' m.escalante91@gmail.com
#' @M56901677v
#' 
#' Usuario específico para S3
#' arn:aws:iam::276401612702:user/S3-PD-user
#' Access key ID: AKIAUAWWR46PKEKOIMFV
#' Secrect access key: AcK6YMVZLJhKd95JekJlCfPHmZYFHiQSgpf1yvr1
#' 
#' Usuario root de Marco:
#' Access key ID: AKIAIUSFNNV6SOM4MQTA
#' Secrect access key: SQfMWX49ENPmR0xH9k68GMnKuA+9QZtgO7Wv+3Ch
#' 

# Specifying keys as environment variables
Sys.setenv("AWS_ACCESS_KEY_ID" = "AKIAUAWWR46PKEKOIMFV",
           "AWS_SECRET_ACCESS_KEY" = "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", 
           "AWS_DEFAULT_REGION" = "us-east-1", 
           "AWS_SESSION_TOKEN" = "")

## Some utility functions

# Show list of buckets
bucketlist()



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
bucket.contents <- get_bucket_df(bucket = "pd-final-project-log")
bucket.contents


