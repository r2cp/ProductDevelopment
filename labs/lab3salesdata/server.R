library(shiny)
library(DT)
library(dplyr)

shinyServer(function(input, output, session) {

    # Actualización de los clientes de acuerdo con el territorio
    # --------------------------------------------------------------------
    territory <- reactive({
        sales_data_sample %>%
            dplyr::filter(TERRITORY == input$territory)
    })
    
    observeEvent(territory(), {
        # Obtener los nombres de clientes en esa región
        choices <- unique(territory()$CUSTOMERNAME)
        
        # Obtener los parámetros en la URL
        params <- url_params()
        
        # Se revisa si viene el parámetro 'customer', de lo contrario la lista se vacía con character(0)
        selected <- ifelse('customer' %in% names(params), params$customer, character(0))
        updateSelectInput(session, "customername", choices = choices, selected = selected)
    })
    
    # Actualización de los números de orden de acuerdo a los clientes
    # --------------------------------------------------------------------
    customer <- reactive({
        territory() %>% 
            dplyr::filter(CUSTOMERNAME == input$customername)
    })
    
    observeEvent(customer(), {
        # Obtener las órdenes para la región y cliente
        choices <- unique(customer()$ORDERNUMBER)
        # Obtener los parámetros en la URL
        params <- url_params()
        
        # Se revisa si viene el parámetro 'order', de lo contrario la lista se vacía con character(0)
        orderSelected <- ifelse('order' %in% names(params), params$order, character(0))
        updateSelectInput(session, "ordernumber", choices = choices, selected = orderSelected)
    })
    
    # Actualizar la tabla de salida
    output$salesdata <- DT::renderDataTable({
        customer() %>% 
            dplyr::filter(ORDERNUMBER == input$ordernumber)
    }, options = list(
        dom = 'tipr' 
        #lengthMenu = list(c(10, -1), c('10', 'All'))
    ))
    
    # Modificación para búsqueda a través parámetros por URL
    # --------------------------------------------------------------------
    url_params <- reactive({
        # Devuelve un objeto 'list' con los parámetros
        query <- parseQueryString(session$clientData$url_search)
        query
        #paste(names(query), query, sep='=', collapse = ', ')
    })
    
    # Cuando los parámetros cambien, modificar los selectInput 
    observe({
        
        # Obtener los parámetros
        params <- url_params()
        
        if ('territory' %in% names(params)) {
            updateSelectInput(session, "territory", selected = params$territory)
        }
    })
    
    # Generación de la URL para compartir
    sharing_url <- eventReactive(input$generateURL, {
        app_url <- "http://ec2-3-86-153-170.compute-1.amazonaws.com/shiny/rstudio/lab3salesdata/"
        full_url <- paste(app_url, "?territory=", input$territory, "&customer=", input$customername, "&order=", input$ordernumber, sep="")
        a(full_url, href=full_url)
    })
    
    output$URLoutput <- renderUI({
        sharing_url()
    })
    
})
