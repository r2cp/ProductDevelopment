library(plumber)

# Where 'plumber.R' is the location of the file shown above
r <- plumb("plumber.R") 

r$run(port=8888, host="0.0.0.0")
