library(shiny)
library(DT)

shinyUI(fluidPage(

    # Application title
    titlePanel("Chance of admit model with API querying"),
    
    # Información del autor
    h4("Product Development - Final project"),
    h4(strong(em("Rodrigo Chang - 19000625"))),
    h4(strong(em("Marco Escalante - 19001148"))), 
    
    # Pestañas con la funcionalidad
    tabsetPanel(
        # Individual prediction
        tabPanel("Individual prediction",
            h4(strong("Individual prediction API")), 
            sidebarLayout(
                sidebarPanel(
                    numericInput("inGRE", "Enter GRE score:", 
                                 value = 300, 
                                 min = 260, max = 340), 
                    numericInput("inTOEFL", "Enter TOEFL score:", 
                                 value = 100, 
                                 min = 0, max = 120),
                    numericInput("inUniversityRating", "Enter University rating:", 
                                 value = 4, 
                                 min = 0, max = 5, step = 1),
                    numericInput("inSOP", "Enter Statement of purpose score (0-5):",
                                 value = 4, 
                                 min = 0, max = 5, step = 0.5),
                    numericInput("inLOR", "Enter Letter of recommendation score (0-5):",
                                 value = 4, 
                                 min = 0, max = 5, step = 0.5),
                    numericInput("inCGPA", "Enter College GPA:", 
                                 value = 8, 
                                 min = 0, max = 10, step = 0.1),
                    checkboxInput("inResearch", "Student has research experience?", value = FALSE), 
                    selectInput("inModel", "Select the model to use: ", 
                                choices = c("svr", "tree"), 
                                selected = "svr", 
                                multiple = FALSE),
                    actionButton("cmdPredictInvididual", 
                                 "Get chance of admit prediction", 
                                 icon = icon("brain"))
                ), 
                mainPanel(
                    h4(em("Results area")),
                    img(src = "https://www.psychologicalscience.org/redesign/wp-content/uploads/2017/09/brainchart.png", 
                        align = "center"), 
                    uiOutput("htmlIndividualOutput")#,
                    # verbatimTextOutput("PredictIndividualOutput")
                )
            ),
            icon = icon("chess-knight")
        ),
        # Batch prediction from file
        tabPanel("Batch prediction | AB testing",
            h4(strong("Batch prediction from file")), 
            sidebarLayout(
                sidebarPanel(
                    fileInput("batchFile", "Select a CSV file"),
                    selectInput("inModelBatch", "Select the model to use: ", 
                                choices = c("svr", "tree", "AB testing"), 
                                selected = "svr", 
                                multiple = FALSE),
                    sliderInput("inModelApart", 
                                "Enter SVR model's share", 
                                value = 1, min = 0, max = 1, step = 0.05),
                    actionButton("cmdBatchPrediction", 
                                 "Get predictions for file", 
                                 icon = icon("brain")),
                    width = 3
                ), 
                mainPanel(
                    h4(em("Results area")),
                    #img(src="crystal-ball.jpg"),
                    DT::dataTableOutput("batchDTOutput"),
                    verticalLayout(
                        #verbatimTextOutput("BatchOutput"), 
                        plotOutput("msePlot")
                    ),
                    width = 9
                )
            ),
            icon = icon("copy")
        )
    )
))
