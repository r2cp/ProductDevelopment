#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

country.data <- read.csv("country-data.csv")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Datos macroeconómicos de países"),
    
    # Información del autor
    h4("Product Development - Laboratorio 1"),
    h4("Rodrigo Chang - 19000625"), 

    # Sidebar con controles para el filtrado del dataframe
    sidebarLayout(
        # Panel lateral izquierdo
        sidebarPanel(
            sliderInput("GDP.range",
                        "Gross Domestic Product",
                        min = min(country.data$Gross.domestic.product..current.prices, na.rm = TRUE),
                        max = max(country.data$Gross.domestic.product..current.prices, na.rm = TRUE),
                        value = quantile(country.data$Gross.domestic.product..current.prices, c(0.25, 1.), na.rm = TRUE)), 
            sliderInput("Inflation.range",
                        "Inflation average",
                        min = min(country.data$Inflation..average.consumer.prices, na.rm = TRUE),
                        max = max(country.data$Inflation..average.consumer.prices, na.rm = TRUE),
                        value = quantile(country.data$Inflation..average.consumer.prices, c(0.25, 1.), na.rm = TRUE)),
            sliderInput("Population",
                        "Population",
                        min = min(country.data$Population, na.rm = TRUE),
                        max = max(country.data$Population, na.rm = TRUE),
                        value = quantile(country.data$Population, c(0.25, 1.), na.rm = TRUE)),
            sliderInput("Unemploy.rate",
                        "Unemployment rate",
                        min = min(country.data$Unemployment.rate, na.rm = TRUE),
                        max = max(country.data$Unemployment.rate, na.rm = TRUE),
                        value = quantile(country.data$Unemployment.rate, c(0.25, 1.), na.rm = TRUE)),
            sliderInput("Exports",
                        "Volume of exports of goods and services",
                        min = min(country.data$Volume.of.exports.of.goods.and.services, na.rm = TRUE),
                        max = max(country.data$Volume.of.exports.of.goods.and.services, na.rm = TRUE),
                        value = quantile(country.data$Volume.of.exports.of.goods.and.services, c(0.25, 1.), na.rm = TRUE)),
            sliderInput("Imports",
                        "Volume of imports of goods and services",
                        min = min(country.data$Volume.of.imports.of.goods.and.services, na.rm = TRUE),
                        max = max(country.data$Volume.of.imports.of.goods.and.services, na.rm = TRUE),
                        value = quantile(country.data$Volume.of.imports.of.goods.and.services, c(0.25, 1.), na.rm = TRUE)),
            selectizeInput("Country.select",
                           "Select countries (all by default)",
                           choices = country.data$Country,
                           selected = country.data$Country, 
                           multiple = TRUE, 
                           options = list(placeholder="Write a country name", hideSelected = TRUE)),
            width = 4
        ),

        # Salida
        mainPanel(
            dataTableOutput("countryData"), 
            textOutput("statusOutput"),
            width = 8
        )
    )
))
