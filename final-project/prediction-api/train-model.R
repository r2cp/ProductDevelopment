library(dplyr)
library(readr)
library(rpart)
library(e1071)

# Carga de datos del modelo
train <- read_csv("data/train.csv")
test <- read_csv("data/test.csv")

# Save the data as JSON format
write_json(train, "data/train.json")
write_json(test, "data/test.json")

# Recursive partitioning tree model
tree.model <- rpart(`Chance of Admit` ~ .,
             data = train, 
             method = "anova")

# SVR model
# Búsqueda de SVR con kernel polinomial con validación cruzada 10 folds
tune.svr <- tune.svm(`Chance of Admit` ~ ., 
                 data = train, 
                 kernel = "polynomial", 
                 degree = c(2:4), 
                 gamma = seq(0.025, 0.15, 0.025), 
                 cost = 2^(0:4))

svr.model <- svm(`Chance of Admit` ~ ., 
                 data = train, 
                 kernel = "polynomial", 
                 degree = tune.svr$best.parameters$degree, 
                 gamma = tune.svr$best.parameters$gamma, 
                 cost = tune.svr$best.parameters$cost)

# Save the models
saveRDS(tree.model, "tree-model.rds")
saveRDS(svr.model, "svr-model.rds")