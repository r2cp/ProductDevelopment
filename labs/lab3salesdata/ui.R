library(shiny)
library(DT)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Sales data with reactivity and URL querying"),
    
    # Información del autor
    h4("Product Development - Laboratorio 3"),
    h4("Rodrigo Chang - 19000625"), 
    
    # Definición del UI
    selectInput("territory", "Territory", choices = unique(sales_data_sample$TERRITORY)),
    selectInput("customername", "Customer", choices = NULL),
    selectInput("ordernumber", "Order number", choices = NULL),
    actionButton("generateURL", "Generate URL for sharing"),
    uiOutput("URLoutput"),
    
    DT::dataTableOutput("salesdata")
))
