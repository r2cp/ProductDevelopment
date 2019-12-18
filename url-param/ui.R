library(shiny)

shinyUI(fluidPage(
    
    h3("Componenetes del URL"),
    
    verbatimTextOutput("textoURL"),
    
    h3("Variables en el url "),
    
    verbatimTextOutput('textoQuery')
    
))