library(dplyr)
library(rpart)
library(plumber)
library(jsonlite)

# Cargar el objeto de modelo del archivo de datos
fit <- readRDS("final_model.rds")

#* @apiTitle Survival Prediction
#* @apiDescription Survival prediction for titanic Data

#' @param Pclass Class that the passenger was on
#' @param Sex Passenger gender 
#' @param Age Passenger age
#' @param SibSp Passenger siblings
#' @param Parch Passenger relatives
#' @param Fare Passenger ticket price
#' @param Embarked Port where the passenger embarked
#' @post /titanic
function(Pclass, Sex, Age, SibSp, Parch, Fare, Embarked) {
  features <- tibble(Pclass=as.integer(Pclass),
                         Sex,
                         Age=as.numeric(Age),
                         SibSp=as.integer(SibSp), 
                         Parch=as.integer(Parch), 
                         Fare=as.numeric(Fare), 
                         Embarked)
  prediction <- predict(fit, features, type = "class")
  out <- list(data=features, prediction=prediction)
  out
}

#' @param a First test number
#' @param b Second test number
#' @post /sum
function(a, b) {
  suma <- as.numeric(a) + as.numeric(b)
  suma
} 


#' @param jsonfile JSON file input
#' @post /jsonproc
function(jsonfile) {
  # Generar una lista con el objeto y su clase
  # Se recibe como "character"
  out <- list(obj=jsonfile, class=class(jsonfile))
  
  # Obtener dataframe del argumento 'jsonfile'
  data <- fromJSON(jsonfile)
  
  # Generar una salida de acuerdo con la clase generada por 'fromJSON'
  if (class(data) == "data.frame") {
    out <- list(obj=data, class=class(data), result=sum(data$a))
  } else {
    out <- list(obj=data, class=class(data))  
  }
  
  # Devolver la lista 'out' que se convertirá a JSON
  out
}
