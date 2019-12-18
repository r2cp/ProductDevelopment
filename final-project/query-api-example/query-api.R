library(jsonlite)
library(readr)
library(httr)

# Cargar datos de prueba
train <- read_csv("data/train.csv")

# Convertir a JSON
jsontrain <- toJSON(tail(train, n=1))

# Consultar el API

# Docker container instance
# url <- "ec2-54-147-59-163.compute-1.amazonaws.com:8888/predict"
# Rstudio-main instance
# url <- "ec2-3-86-153-170.compute-1.amazonaws.com:8888/predict"
# Rstudio-API service instance
url <- "ec2-3-86-209-44.compute-1.amazonaws.com:8888/predict"

# Get the response object
response <- POST(url, 
                 body = list(jsondata = jsontrain, 
                             model = "svr", 
                             user = "mrrobot"), 
                 encode = "json")

# Obtener la respuesta del modelo como una lista
cont <- content(response)$prediction
cont
