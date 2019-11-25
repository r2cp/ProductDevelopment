library(RMySQL)

# Función para ejecutar queries
getQuery <- function(queryString) {
  # Conexión con la base de datos
  drv <- dbDriver("MySQL")
  con <- dbConnect(drv, dbname = "electric_data",
                   host = "electricdata-lab2.clcnabegfwn3.us-east-1.rds.amazonaws.com",
                   port = 3306,
                   user = "admin",
                   password = "rgD6qRijeazwg6cQdtq2")
  # Ejecutar el query
  res <- dbGetQuery(con, queryString)
  dbDisconnect(con)
  return(res)
}

# con <- dbConnect(drv, dbname = "electric_data",
#                  host = "electricdata-lab2.clcnabegfwn3.us-east-1.rds.amazonaws.com", 
#                  port = 3306,
#                  user = "admin", 
#                  password = "rgD6qRijeazwg6cQdtq2")

# con <- dbConnect(drv, dbname = "electric_data",
#                  host = Sys.getenv("DB_HOST"), 
#                  port = strtoi(Sys.getenv("DB_PORT")),
#                  user = Sys.getenv("DB_USER"), 
#                  password = Sys.getenv("DB_PASSWORD"))


# Sys.setenv(DB_PASSWORD="rgD6qRijeazwg6cQdtq2",
#            DB_PORT=3306,
#            DB_HOST="electricdata-lab2.clcnabegfwn3.us-east-1.rds.amazonaws.com",
#            DB_USER = "admin")