library(shiny)
library(jsonlite)
library(httr)
library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)

shinyServer(function(input, output, session) {

  # Update slider percentage according to selectInput and sliderInput
  # -----------------------------------------------------------
  observeEvent(input$inModelBatch, {
    if (input$inModelBatch == "svr") {
      updateSliderInput(session, inputId = "inModelApart", value = 1)
    } else if (input$inModelBatch == "tree") {
      updateSliderInput(session, inputId = "inModelApart", value = 0)
    }
  })
  
  observeEvent(input$inModelApart, {
    if (input$inModelApart == 1) {
      updateSelectInput(session, inputId = "inModelBatch", selected = "svr")
    } else if (input$inModelApart == 0) {
      updateSelectInput(session, inputId = "inModelBatch", selected = "tree")
    } else {
      updateSelectInput(session, inputId = "inModelBatch", selected = "AB testing")
    }
  })
  
  
  
  # Code for individual prediction
  # -----------------------------------------------------------
  
  getIndividualPrediction <- eventReactive(input$cmdPredictInvididual, {
    # Get values and set the dataframe or tibble for prediction
    data <- tibble(
      `GRE Score` = input$inGRE,
      `TOEFL Score` = input$inTOEFL,
      `University Rating` = input$inUniversityRating,
      SOP = input$inSOP,
      LOR = input$inLOR,
      CGPA = input$inCGPA,
      Research = 1.0*input$inResearch)
    
    # Convert data to JSON
    jsondata <- toJSON(data)
    
    # Query the API
    response <- POST(API_URL, body = list(
        jsondata = jsondata, 
        model = input$inModel, 
        user = "clientapp"), 
      encode = "json")
    
    # Get the responses
    cont <- content(response)$prediction
    
    # Generate UI response
    h1(strong(paste("Chance of Admit: ", cont[[1]], sep = "")))
    
  })
  
  output$htmlIndividualOutput <- renderUI({
    getIndividualPrediction()
  })
  
  # output$PredictIndividualOutput <- renderPrint({
  #   getIndividualPrediction()
  # })
  
  
  
  
  # Code for batch prediction and AB testing
  # -----------------------------------------------------------
  
  # verbatim BatchOutput code
  # output$BatchOutput <- renderPrint({
  #   print(errdata())
  # })
  
  # dataTableOutput batchDTOutput code
  output$batchDTOutput <- DT::renderDataTable({
    getBatchPrediction()
  }, selection = "single", options = list(
    dom = 'ltipr', 
    pageLength = 10)
  )
  
  # Get the dataframe in the file as reactive value
  batch.data <- reactive({
    # Read the file 
    df <- read_csv(input$batchFile$datapath)
    df
  })
  
  # Function to get combined tibble with data and predictions per model
  getBatchPrediction <- eventReactive(input$cmdBatchPrediction, {
    # Get the file data
    data <- batch.data()
    
    # Convert data to JSON
    jsondata <- toJSON(data)
    
    # Falta implementar la lógica de AB testing, generación de métricas de performance del modelo
    # y gráficas de las medidas de error
    
    # If all the data is sent to one of the two models
    if (input$inModelBatch %in% c("svr", "tree")) {
      # Query the API
      response <- POST(API_URL, body = list(
        jsondata = jsondata, 
        model = input$inModelBatch, 
        user = "clientapp"), 
        encode = "json")
      
      # Get the responses and set up a prediction tibble
      pred.tibble <- tibble(prediction = unlist(content(response)$prediction), 
                            model = input$inModelBatch)
    } 
    # This is the case for sending part of the data to model A and the other part to model B
    else {
      # Get index to slice data using model A
      idx <- as.integer(input$inModelApart*nrow(data))
      dataA <- data %>% dplyr::slice(1 : idx)
      dataB <- data %>% dplyr::slice(idx+1 : nrow(data))
      
      # Query API for both models predictions
      responseA <- POST(API_URL, body = list(
        jsondata = toJSON(dataA), 
        model = "svr", 
        user = "clientapp"), 
        encode = "json")
      
      responseB <- POST(API_URL, body = list(
        jsondata = toJSON(dataB), 
        model = "tree", 
        user = "clientapp"), 
        encode = "json")
      
      # Set up the prediction tibble
      pred.tibble <- tibble(prediction = c(unlist(content(responseA)$prediction), unlist(content(responseB)$prediction)), 
                            model = c(rep("svr", nrow(dataA)), rep("tree", nrow(dataB))))
    }
    
    # Return the data and prediction tibble
    cmb.tibble <- dplyr::bind_cols(data, pred.tibble)
    
    # Set reactive tibble for plots
    # reactivePredictions$cmb.tibble <- cmb.tibble
    
    # Return tibble
    cmb.tibble
  })
  
  
  
  # Update the plots according to reactive predictions
  # -----------------------------------------------------------
  
  # Compute error measures after the predictions
  errdata <- reactive({
    # Get the predictions tibble and compute error
    err <- getBatchPrediction() %>%
      dplyr::select(c(`Chance of Admit`, prediction, model)) %>%
      dplyr::mutate(abserr = abs(prediction - `Chance of Admit`), sqerr = (prediction - `Chance of Admit`)^2) %>%
      dplyr::group_by(model) %>%
      dplyr::summarise(MSE = mean(sqerr), MAE = mean(abserr), RMSE = sqrt(mean(sqerr))) %>% 
      tidyr::gather("error.measure", "value", -1)
  })
  

  output$msePlot <- renderPlot({
    # Plot the err data
    ggplot(errdata(), aes(x=error.measure, y = value, fill=model)) + 
      geom_bar(stat = "identity", position=position_dodge()) +
      ggtitle("Model's performance measures") +
      xlab("Measure") +
      ylab("") +
      theme(text = element_text(size=20))
  })
})
