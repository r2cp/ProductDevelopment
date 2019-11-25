#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(dplyr)

country.data <- read.csv("country-data.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$countryData <- DT::renderDataTable({

        # Tomar el rango de entrada y filtrar
        gdp <- input$GDP.range
        infl.avg <- input$Inflation.range
        pop <- input$Population
        unemploy <- input$Unemploy.rate
        exports <- input$Exports
        imports <- input$Imports
        
        countries <- input$Country.select
        
        country.df <- country.data %>%
            filter((Country %in% countries)
                   & (Gross.domestic.product..current.prices >= gdp[1] & Gross.domestic.product..current.prices <= gdp[2])
                   & (Inflation..average.consumer.prices >= infl.avg[1] & Inflation..average.consumer.prices <= infl.avg[2])
                   & (Population >= pop[1] & Population <= pop[2])
                   & (Unemployment.rate  >= unemploy[1] & Unemployment.rate  <= unemploy[2])
                   & (Volume.of.exports.of.goods.and.services  >= exports[1] & Volume.of.exports.of.goods.and.services  <= exports[2])
                   & (Volume.of.imports.of.goods.and.services  >= imports[1] & Volume.of.imports.of.goods.and.services  <= imports[2])
                   )

        country.df
    })
    
    output$statusOutput <- renderText({
        paste("Number of selected countries:", length(input$Country.select))
    })

})
