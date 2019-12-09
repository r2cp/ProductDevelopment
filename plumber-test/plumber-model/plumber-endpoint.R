# Este archivo corresponde a la creación del endpoint
library(plumber)
r <- plumb('prediction-api.R')
r$run(host = "0.0.0.0", port = 8001)
