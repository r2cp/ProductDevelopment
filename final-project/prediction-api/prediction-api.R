library(dplyr)
library(rpart)
library(e1071)
library(plumber)
library(jsonlite)

# Cargar los modelos
svr.model <- readRDS("svr-model.rds")
tree.model <- readRDS("tree-model.rds")

#* @apiTitle Admissions Survival Prediction
#* @apiDescription Chance of admission to college prediction

#' @param jsondata The data for the model in JSON format, one or several rows.
#' @param modelno Number of model to use for the prediction
#' @post /predict
#' @get /predict
function(jsondata, modelno) {
  # Get the data as a dataframe 
  data <- fromJSON(jsondata)
  print("JSON data received from file")
  
  # Generar una salida de acuerdo con el modelo enviado
  if (modelno == "1") {
    prediction <- predict(svr.model, data)
    print("Prediction made from SVR model")
  } else if (modelno == "2") {
    prediction <- predict(tree.model, data)
    print("Prediction made from tree model")
  } else {
    print("Incorrect model specified")
    prediction <- NA
  }
  
  # Conformar una lista de salida
  out <- list(prediction = prediction)
  
  # Devolver la lista 'out' que se convertirá a JSON
  out
}
