library(jsonlite)
library(readr)
library(httr)

# Cargar datos de prueba
train <- read_csv("data/train.csv")

# Convertir a JSON
jsontrain <- toJSON(head(train))

# Consultar el API
# Dirección: ec2-54-147-59-163.compute-1.amazonaws.com:8888/predict
url <- "ec2-54-147-59-163.compute-1.amazonaws.com:8888/predict"
response <- POST(url, 
                 body = list(jsondata = jsontrain, modelno = "1"), 
                 encode = "json")

# Obtener la respuesta del modelo como una lista
cont <- content(response)$prediction
cont
