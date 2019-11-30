library(shiny)
library(DT)

shinyUI(fluidPage(
  
  tabsetPanel(tabPanel("DT library demo",
                       h2("default"),
                       DT::dataTableOutput("diamonds_tbl"),
                       h2("Table Size options"),
                       DT::dataTableOutput('diamonds_tbl_options'),
                       h2("Table with additional options"),
                       DT::dataTableOutput("diamonds_tbl_coltype")),
              # Segunda pestaña: utilizaremos interactividad
              tabPanel("DT interaction rows",
                       splitLayout(
                         DT::dataTableOutput("x1"),
                         plotOutput("x2")
                       )),
              # Tercera pestaña
              tabPanel("Interactivo general",
                       splitLayout(
                         DT::dataTableOutput("x3"),
                         verbatimTextOutput("x4")
                       )),
              # Para subir archivos
              tabPanel("Upload/Download",
                       fileInput("get_file", "Select a file"),
                       h2("Contenido del archivo"),
                       DT::dataTableOutput("uploaded_file_tbl"),
                       downloadButton("download_df", "Descargar datos"))
  )
  
)) 