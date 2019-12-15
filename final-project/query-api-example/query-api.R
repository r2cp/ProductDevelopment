library(jsonlite)
library(readr)
library(httr)

# Cargar datos de prueba
train <- read_csv("data/train.csv")

# Convertir a JSON
jsontrain <- toJSON(head(train), n=3)

# Consultar el API
# Dirección: ec2-54-147-59-163.compute-1.amazonaws.com:8888/predict
# Docker container instance
# url <- "ec2-54-147-59-163.compute-1.amazonaws.com:8888/predict"
# Rstudio instance
# url <- "ec2-3-86-153-170.compute-1.amazonaws.com:8888/predict"
response <- POST(url, 
                 body = list(jsondata = jsontrain, 
                             model = "svr", 
                             user = "mrrobot"), 
                 encode = "json")

# Obtener la respuesta del modelo como una lista
cont <- content(response)$prediction
cont
