library(RMySQL)
drv <- dbDriver("MySQL")

# Base de datos de prueba
con <- dbConnect(drv, dbname = "pd",
                 host = Sys.getenv("DB_HOST"), 
                 port = strtoi(Sys.getenv("DB_PORT")),
                 user = Sys.getenv("DB_USER"), 
                 password = Sys.getenv("DB_PASSWORD"))
games <- dbGetQuery(con,"select * FROM Persona")
dbDisconnect(con)


# Base de datos para laboratorio 2 con datos de electricidad
con <- dbConnect(drv, dbname = "electric_data",
                 host = Sys.getenv("DB_HOST"), 
                 port = strtoi(Sys.getenv("DB_PORT")),
                 user = Sys.getenv("DB_USER"), 
                 password = Sys.getenv("DB_PASSWORD"))
res <- dbGetQuery(con,"select max(consumption_eur) as max_eur, max(consumption_sib) as max_sib, 
                  max(price_eur) as max_price_eur, max(price_sib) as max_price_sib, 
                  min(consumption_eur) as min_eur, min(consumption_sib) as min_sib, 
                  min(price_eur) as min_price_eur, min(price_sib) as min_price_sib,
                  min(timestep) as min_timestep, max(timestep) as max_timestep
                  FROM consumption limit 1")
dbDisconnect(con)


res <- dbGetQuery(con,"select * 
                  from consumption 
                  where timestep between '2006-09-01' and '2006-09-02 23:00:00'")

