library(shiny)
library(dplyr)
library(DT)
library(jsonlite)
library(ggplot2)
library(aws.s3)

shinyServer(function(input, output) {
    
    # Log table data as reactive function of daterange
    bucket.contents <- reactive({
        # Get the bucket file list
        bucket.cont <- get_bucket_df(bucket = Sys.getenv("API_BUCKET_NAME")) %>% 
            dplyr::filter(as.Date(LastModified) >= input$dateRange[1] & as.Date(LastModified) <= input$dateRange[2]) %>%
            dplyr::arrange(desc(as.Date(LastModified))) %>%
            # dplyr::mutate(Timestamp = as.Date.POSIXct(LastModified)) %>%
            dplyr::select(-Owner_ID)
        
        # Return the object
        bucket.cont
    })
    
    # Output of the log table
    output$logData <- DT::renderDataTable({
        # Get the bucket contents
        bucket.contents()
    }, selection = "single", options = list(
        dom = 'tipr', 
        pageLength = 5)
    )    
    
    # Output of the verbatim log file
    # ---------------------------------------------------------
    
    # Function to get the selected log file
    getSelectedLog <- eventReactive(input$cmdloadLogs, {
        # Check if there's a selected row
        if (is.null(input$logData_rows_selected)) {
            print("Please, select a log file from the table")
        } else {
            # Get the selected log row from the table
            selected <- bucket.contents()[input$logData_rows_selected, ]
            # Get the file from the S3 service
            filename <- selected$Key
            jsonfile <- s3read_using(FUN = read_json, 
                                     object = filename, 
                                     bucket = Sys.getenv("API_BUCKET_NAME"))
            # Get the log file as a list
            loglist <- fromJSON(jsonfile[[1]])
            print(loglist)
        }
    })
    
    output$logFileResult <- renderPrint({
        getSelectedLog()
    })
    
    # Output general statistics for models
    # ---------------------------------------------------------
    # Model statistics as reactive tibble
    modelstats <- reactive({
        # Get the keys in the output log table
        df <- bucket.contents()$Key
        # Get the model stats with helper function as list of tibbles
        results <- lapply(df, hlp_getModelStats)
        # Get one big tibble
        stats <- dplyr::bind_rows(results)
        stats
    })
    
    output$modelStatisticsOutput <- renderUI({
        # Get model stats
        stats <- modelstats()
        
        # Compute the model statistics
        avg.payload <- mean(stats$payload.size)
        
        # Total number of users
        total.users <- stats %>%
            count(user) %>%
            nrow()
        
        # Return HTML output
        verticalLayout(
            h4(strong(em(paste("Overall mean payload size: ", avg.payload, sep = "")))), 
            h4(strong(em(paste("Overall model users: ", total.users, sep = ""))))
        )
        
    })
    
    
    
    # Render plots from model statistics
    # ---------------------------------------------------------
    output$modelCountsPlot <- renderPlot({
        # Get model stats
        prefmodel <- modelstats() %>% 
            count(model)
        # Get model usage in %
        prefmodel <- prefmodel %>%
            mutate(usage = 100*n/sum(prefmodel$n)) 
        
        # Bar plot
        # ggplot(prefmodel, aes(x = model, y=usage)) + 
        #     geom_bar(stat = "identity", fill = "darkblue") +
        #     ggtitle("Model usage in %") +
        #     xlab("Model") +
        #     ylab("Model usage in % of time")
        
        # Pie plot
        ggplot(prefmodel, aes(x = "", y=usage, fill=model)) +
            geom_bar(stat = "identity", width = 1) +
            coord_polar(theta = "y", start = 0) +
            scale_fill_brewer(palette="Dark2") +
            theme_minimal() +
            ggtitle("Model usage in %") +
            xlab("") +
            ylab("") +
            theme(text = element_text(size=20))
    })
    
    
    output$avgPayloadPlot <- renderPlot({
        # Compute average payload size per model 
        avgpayload <- modelstats() %>% 
            dplyr::group_by(model) %>%
            summarise(m.payload = mean(payload.size))
        
        ggplot(avgpayload, aes(x = model, y = m.payload)) + 
            geom_bar(stat = "identity", fill = "darkgreen") +
            coord_flip() +
            ggtitle("Average payload sent to models") +
            xlab("Model") +
            ylab("Average number of rows per request") +
            theme(text = element_text(size=20))
    })
    
    
    output$userRequestsPlot <- renderPlot({
        # Compute average payload per user
        userreq <- modelstats() %>%
            dplyr::group_by(user) %>%
            summarise(m.payload.user = mean(payload.size))
        
        # Generate the plot
        ggplot(userreq, aes(x = user, y = m.payload.user)) + 
            geom_bar(stat = "identity", fill = "darkred") +
            coord_flip() + 
            ggtitle("Average payload per user") +
            xlab("User") +
            ylab("Average payload size") +
            theme(text = element_text(size=20))
        
    })
    
})
