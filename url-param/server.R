

library(shiny)

shinyServer(function(input, output,session) {
    
    output$textoURL <- renderText({
        
        paste(sep='',
              
              'protocol: ', session$clientData$url_protocol, "\n",
              
              'hostname: ', session$clientData$url_hostname, "\n",
              
              'pathname: ', session$clientData$url_pathname, "\n",
              
              'port: ', session$clientData$url_port, "\n",
              
              'search: ', session$clientData$url_search, "\n")
        
    })
    
    output$textoQuery <- renderText({
        
        query <- parseQueryString(session$clientData$url_search)
        
        paste(names(query), query, sep='=', collapse = ', ')
        
        #str(query$var)
        
    })    
    
    
    
})

