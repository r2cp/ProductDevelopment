#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(DT)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$diamonds_tbl <- DT::renderDataTable({
    diamonds
  })
  
  output$diamonds_tbl_options <- DT::renderDataTable({
    diamonds
  },
    options = list(lengthMenu = list(c(5, 10, -1), c("5 elementos", "10", "all")),
                   pageLength = 7, 
                   dom = 'tipr')
  )
  
  
  output$diamonds_tbl_coltype <- DT::renderDataTable({
    # Se debe modificar el dataframe antes de enviar a la función DT::dataframe, 
    #   por eso se utiliza el mutate dentro del argumento
    # Filtros en la parte superior para buscar por campos
    # Quitamos la búsqueda global quitando el 'f'
    DT::datatable(diamonds %>% mutate(depth = round(depth/100, 2)), 
                  filter = 'top',
                  options = list(dom = 'ltipr')) %>%
      formatCurrency("price") %>%
      formatPercentage("depth") %>% 
      formatString(c("x", "y", "z"), suffix = "mm")
    })
  
  
  output$x1 <- DT::renderDataTable(cars, options = list(dom = 'ltipr'))
  
  output$x2 <- renderPlot({
    s <- input$x1_rows_selected
    plot(cars)
    
    if (length(s)) points(cars[s,, drop=FALSE], pch=12, cex=2)
    
  })
  
  # Obtener las filas seleccionadas, las mostradas en la página, y las seleccionadas
  mtcars2 <- mtcars[,c('hp','mpg')]
  
  output$x3 <- DT::renderDataTable(mtcars2)
  
  output$x4 <- renderPrint({
    cat('Filas en la pagina actual:\n\n')
    cat(input$x3_rows_current,sep=', ')
    cat('\n\nTodas las filas:\n\n')
    cat(input$x3_rows_all, sep=', ')
    cat('\n\n Filas seleccionadas:\n\n')
    cat(input$x3_rows_selected, sep=', ')
  }) 
  
  # Carga de archivos
  # Creamos una función reactiva, que lee el archivo subido. 
  # Si el archivo no ha sido cargado, devuelve NULL
  upload_file <- reactive({
    inFile <- input$get_file
    
    if (is.null(inFile)) {
      return(NULL)
    } 
    
    uploaded_file <- read.csv(inFile$datapath)
    # Modificación : agregamos la fecha en que se cargó el archivo
    uploaded_file$upload_date <- Sys.Date()
    return(uploaded_file)
  })
  
  # Configuramos la tabla de salida con el archivo CSV cargado
  output$uploaded_file_tbl <- DT::renderDataTable({
    upload_file()
  })
  
  # Configuramos la descarga de datos
  output$download_df <- downloadHandler(
    # El nombre de archivo puede ser una función, se puede agregar fecha u otros campos relevantes
    filename = function(){'download_file.csv'},
    # Esta función va a escribir el csv
    content = function(file) {
      write.csv(upload_file(), file)
    }
  )
  
  
  
  
})
