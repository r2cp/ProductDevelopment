library(shiny)
library(DT)


shinyUI(fluidPage(
    
    # Application title
    titlePanel("Model log filter app"),
    
    # Información del autor
    h4("Product Development - Final project"),
    h4(strong(em("Rodrigo Chang - 19000625"))),
    h4(strong(em("Marco Escalante - 19001148"))),
    
    # Sidebar con controles para el filtrado del dataframe
    sidebarLayout(
        # Left side panel to select date range
        sidebarPanel(
            dateRangeInput("dateRange", "Select the date range", 
                           start = "2019-12-01",
                           end = "2019-12-31"), 
            p(strong("Select a record and press the button")),
            actionButton("cmdloadLogs", "Load selected log", icon = icon("download")), 
            width = 3
        ),
        
        # DT output with log files
        mainPanel(
            DT::dataTableOutput("logData"), 
            width = 9
        )
    ), 
    # Final part of app, some plots of model utilization
    h3("Usage statistics"),
    fluidRow(
        column(width = 4, 
               plotOutput("modelCountsPlot")
        ), 
        column(width = 4, 
               plotOutput("avgPayloadPlot")
        ), 
        column(width = 4, 
               plotOutput("userRequestsPlot")
        )
    ),
    # Bottom part with results for record
    fluidRow(
        column(width = 9,
               h3("Log file contents"), 
               verbatimTextOutput("logFileResult")
        ), 
        column(width = 3, 
               h3("Model statistics"), 
               img(src="https://cdn.pixabay.com/photo/2019/11/13/14/17/statistics-4623853_960_720.png", width = "400px"),
               uiOutput("modelStatisticsOutput")
        )
    )
    
))
