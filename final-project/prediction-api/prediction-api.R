library(dplyr)
library(rpart)
library(e1071)
library(plumber)
library(jsonlite)
library(lubridate)
library(digest)
library(aws.s3)

# Cargar los modelos
svr.model <- readRDS("svr-model.rds")
tree.model <- readRDS("tree-model.rds")

# Get the bucket name to dump the log files
BUCKET_NAME <- Sys.getenv("API_BUCKET_NAME")


#* @apiTitle Admissions Survival Prediction
#* @apiDescription Chance of admission to college prediction

#* Log some information about the incoming request
#* @filter logger
function(req){
  # cat(as.character(Sys.time()), "-", 
  #     req$REQUEST_METHOD, req$PATH_INFO, "-", 
  #     req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
  plumber::forward()
}

#' @param jsondata The data for the model in JSON format, one or several rows.
#' @param modelno Number of model to use for the prediction
#' @param user The user name querying the API
#' @post /predict
#' @get /predict
function(jsondata, model, user, req) {
  # Get the data as a dataframe 
  data <- fromJSON(jsondata)
  print("JSON data received from file")
  
  
  # Generar una salida de acuerdo con el modelo enviado
  if (model == "svr") {
    prediction <- predict(svr.model, data)
    print("Prediction made from SVR model")
  } else if (model == "tree") {
    prediction <- predict(tree.model, data)
    print("Prediction made from tree model")
  } else {
    print("Incorrect model specified")
    prediction <- NA
  }
  
  # Form a log list
  log.list <- list(user = user,
                   endpoint="admissions", 
                   user.agent = req$HTTP_USER_AGENT,
                   req.method =  req$REQUEST_METHOD,
                   remote.addr = req$REMOTE_ADDR, 
                   timestamp = now(), 
                   model = model, 
                   payload = data,
                   prediction = prediction)
  
  ## Save the log in S3
  # Generate a filename
  filename <- paste(Sys.Date(), "-", substring(digest(paste(as.character(log.list$timestamp),
                                       req$HTTP_USER_AGENT,
                                       req$REMOTE_ADDR, sep = "+"),
                                   algo = "sha1"), 1, 15), ".json", sep = "")
  print(paste("Filename is:", filename))
  
  # Save the JSON file locally
  log.json <- toJSON(log.list)
  write_json(log.json, filename)
  
  # Push the JSON file in S3 bucket with credentials saved in ENV VARS
  result <- tryCatch({
    put_object(file = filename, 
               object = filename, 
               bucket = BUCKET_NAME, 
               session_token = NULL)
  }, warning = function(cond) {
    print("A warning has raised. Original message: ")
    print(cond)
  }, error = function(cond) {
    print("An error has ocurred. Original message: ")
    print(cond)
    print("# Ignoring saving log in S3")
  }, finally = {
    print("Processed file for S3 completed")
    # Clean up the local log file
    file.remove(filename)
  })
  
  
  # Set up the output list for prediction
  out <- list(prediction = prediction)
  
  # Return output prediction (will be converted to JSON)
  out
}
