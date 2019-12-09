library(dplyr)
library(rpart)
library(plumber)

fit <- readRDS("final_model.rds")

#* @apiTitle Survival Prediction
#* @apiDescription Survival prediction for titanic Data#' @param Pclass Class that the passenger was on
#' @param Sex Passenger gender 
#' @param Age Passenger age
#' @param SibSp Passenger siblings
#' @param Parch Passenger relatives
#' @param Fare Passenger ticket price
#' @param Embarked Port where the passenger embarked
#' @post /titanicfunction(Pclass, Sex, Age, SibSp, Parch, Fare, Embarked){
  features <- data_frame(Pclass=as.integer(Pclass),
                         Sex,
                         Age=as.numeric(Age),
                         SibSp=as.integer(SibSp), 
                         Parch=as.integer(Parch), 
                         Fare=as.numeric(Fare), 
                         Embarked)
  out<-predict(fit, features, type = "class")
  as.character(out)
}
