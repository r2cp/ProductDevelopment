library(dplyr)
library(rpart)
library(plumber)
library(jsonlite)

# Cargar el objeto de modelo del archivo de datos
fit <- readRDS("final_model.rds")

#* @apiTitle Titanic Survival Prediction
#* @apiDescription Survival prediction for Titanic Data

#' @param Pclass Class that the passenger was on
#' @param Sex Passenger gender 
#' @param Age Passenger age
#' @param SibSp Passenger siblings
#' @param Parch Passenger relatives
#' @param Fare Passenger ticket price
#' @param Embarked Port where the passenger embarked
#' @get /titanic
#' @post /titanic
function(Pclass, Sex, Age, SibSp, Parch, Fare, Embarked=NA) {
  # Convertir campos a numéricos
  Pclass = as.integer(Pclass)
  SibSp = as.integer(SibSp) 
  Parch = as.integer(Parch) 
  Fare = as.numeric(Fare)
  
  # Validar el campo 'Sex'
  if (!(Sex %in% c('male', 'female'))) {
    error <- TRUE
    status <- "Error: el campo 'Sex' debe contener solamente los valores 'male' o 'female'."
  } else if (!(Embarked %in% c("S","C","Q"))) {
    error <- TRUE
    status <- "Error: el campo 'Embarked' debe contener solo valores 'S', 'C', 'Q'"
  } else if (is.na(Pclass) | is.na(SibSp) | is.na(Parch) | is.na(Fare)) {
    error <- TRUE
    status <- "Error: los campos numéricos contienen errores."
  }
    else {
    error <- FALSE
    status <- "Predicción computada correctamente."
  }
  
  if (!error) {
    features <- tibble(Pclass=as.integer(Pclass),
                       Sex,
                       Age=as.numeric(Age),
                       SibSp=as.integer(SibSp), 
                       Parch=as.integer(Parch), 
                       Fare=as.numeric(Fare), 
                       Embarked)
    prediction <- predict(fit, features, type = "class")
  } else {
    prediction <- NA
  }
  
  author.info <- "### Rodrigo Chang - 19000625 - Laboratorio 4 ###
  # API de predicción para Titanic con *validación* en los campos
  # Puede consultar esta API (/titanic) en su versión GET o POST"
  
  out <- list(info=author.info, status=status, prediction=prediction)
  out
}

#' @param a First test number
#' @param b Second test number
#' @post /sum
function(a, b) {
  suma <- as.numeric(a) + as.numeric(b)
  suma
} 

#' @param a First test number
#' @param b Second test number
#' @get /sum
function(a, b) {
  suma <- as.numeric(a) + as.numeric(b)
  list(result=suma, t=NA)
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
