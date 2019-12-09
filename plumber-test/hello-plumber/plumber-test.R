library(plumber)

#' @apiTitle Tutorial plumber
#' @apiDescription Este es el primer API creado utilizando plumber

#' @param msg Aquí recibimos el mensaje que vamos a replicar
#' @get /echo
function (msg = '') {
  list(msg = paste0("El mensaje es : '", msg, "'"))
}

# Para obtener una gráfica
#' @png
#' @get /plot
function () {
  plot(hist(rnorm(100)))
}


#' Devuelve la suma de dos números
#' @param a
#' @param b
#' @post /sum
function (a,b) {
  as.numeric(a) + as.numeric(b)
}
