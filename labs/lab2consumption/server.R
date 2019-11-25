library(shiny)
library(shinyalert)
library(DT)
library(RMySQL)
library(lubridate)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    # Obtener los valores de la tabla en forma reactiva
    # -----------------------------------------------------------  
    dataValues <- reactive({
        #DATE_ADD("2017-06-15", INTERVAL 10 DAY)
        # Armar el query
        query <- sprintf("select * from consumption where (timestep between '%s' and date_add('%s', interval 1 day)) and
                         (consumption_eur between %f and %f) and
                         (consumption_sib between %f and %f) and
                         (price_eur between %f and %f) and
                         (price_sib between %f and %f)", 
                         input$TimestepRange[1], input$TimestepRange[2],
                         input$ConsumptionEUR[1], input$ConsumptionEUR[2],
                         input$ConsumptionSIB[1], input$ConsumptionSIB[2],
                         input$PriceEUR[1], input$PriceEUR[2], 
                         input$PriceSIB[1], input$PriceSIB[2])
        #print(query)
        res <- getQuery(query)
        
        # Convertir las fechas y horas
        #res$timestep <- ymd_hms(res$timestep)
        
        # Devolver el dataframe con el resultset
        res
    })
  
  
    # Salida de la tabla de consulta
    # -----------------------------------------------------------
    output$consumptionData <- DT::renderDataTable({
      # Revisar cómo cambiar las opciones para mostrar la tabla
      #DT::datatable(dataValues(), 
      #              options = list(pageLength = 25, 
      #                             selection = "single"))
      
      dataValues()
    }, selection = "single")
    
    # Acción para el botón de insertar
    # -----------------------------------------------------------
    # Patrón #1, trigger arbitrary code with observeEvent
    # observeEvent(input$insertButton, {
    #   # Run code when insertButton is pressed
    # })
    
    # Patrón #2, delay reactions with  eventReactive
    insertProc <- eventReactive(input$insertButton, {
      # Agregar registro a la base de datos
      query <- sprintf("insert into consumption (timestep, consumption_eur, consumption_sib, price_eur, price_sib) 
                 values (now(), %f, %f, %f, %f)", input$ConsumptionEURIn, input$ConsumptionSIBIn, input$PriceEURIn, input$PriceSIBIn)
      
      res <- getQuery(query)
      print("Entry has been added to database successfully!")
    })
    
    output$insertOutput <- renderPrint({
      # Llamada al procedimiento de inserción de datos
      insertProc()
    })
    
    
    
    # Actualizar los campos en el área de update 
    # -----------------------------------------------------------
    # Actualizar los textInput y numericInput al seleccionar fila
    observeEvent(input$consumptionData_rows_selected, {
      
      # Obtener la fila seleccionada de datos
      #print(input$consumptionData_rows_selected)
      df <- dataValues()[input$consumptionData_rows_selected, ]
      
      # Actualizar los campos de update
      updateTextInput(session, "updTimestep", value = df$timestep)
      updateTextInput(session, "updConsumptionEUR", value = df$consumption_eur)
      updateTextInput(session, "updConsumptionSIB", value = df$consumption_sib)
      updateTextInput(session, "updPriceEUR", value = df$price_eur)
      updateTextInput(session, "updPriceSIB", value = df$price_sib)
      
      # Actualizar los campos para el delete
      updateTextInput(session, "delTimestep", value = df$timestep)
    })
    
    
    # Código del botón para update
    updateProc <- eventReactive(input$updateButton, {
      # Actualizar el registro en la base de datos
      query <- sprintf("update consumption set consumption_eur=%f, consumption_sib=%f, price_eur=%f, price_sib=%f 
                       where timestep='%s' limit 1", 
                       input$updConsumptionEUR, 
                       input$updConsumptionSIB, 
                       input$updPriceEUR, 
                       input$updPriceSIB, 
                       input$updTimestep)
      #print(query)
      
      # Show a modal when the button is pressed
      #shinyalert("Información", query, type = "error")
      
      # Ejecutar el query de update
      res <- getQuery(query)
      print("Update applied to database successfully!")
    })
    
    
    # Actualizar el status de salida
    output$updateOutput <- renderText({
      updateProc()
    })
    
    
    # Borrar registros de la tabla
    # -----------------------------------------------------------
    deleteProc <- eventReactive(input$deleteButton, {
      # Actualizar el registro en la base de datos
      query <- sprintf("delete from consumption  
                       where timestep='%s' limit 1", 
                       input$updTimestep)
      #print(query)
      
      # Ejecutar el query de update
      res <- getQuery(query)
      
      # Actualizar la tabla 
      dataValues()
      
      # Mostrar status
      print("Record deleted from database successfully!")
    })
    
    
    # Actualizar el status de salida
    output$deleteOutput <- renderText({
      deleteProc()
    })
    
    
    
    

    # Pendientes
    # -----------------------------------------------------------
    # 1 - Modificar el UI para que actualice los campos al seleccionar una fila de la tabla,
    #     quizás con un observeEvent de input$tabla_selected_rows (algo así)
    
    # 2 - Hacer el textInput de timestep no editable.
    # 3 - Agregar el botón de update para que modifique tomando los valores. Las acciones de este botón se pueden hacer 
    #     con cualquiera de los 2 patrones de arriba
    
    # 4 - Agregar otro textInput que se actualice con el timestep de la fila seleccionada.
    #     Agregar botón de delete y activar para borrar la fila seleccionada
    
    # 5 - Agregar headers para que Preng no se confunda de que lo hice todo en la misma hoja. Que 
    #     quede claro que hice todas las funciones requeridas.
})
