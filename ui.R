
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

load("./data.Rdata")

shinyUI(fluidPage(

  # Application title
  titlePanel("Índice Nacional de Precios al Consumidor"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        dateRangeInput("dates",
                  "Rango de fechas:",
                  language = "es",
                  start = min(data$date),
                  end = max(data$date),
                  min = min(data$date),
                  max = max(data$date)),
        
        selectInput("cities",   
                    "Ciudades:",
                    choices = as.list(names(data[1:12])),
                    multiple = TRUE,
                    selected = c("Nacional")),
        
        selectInput("domains",   
                    "Dominios:",
                    choices = levels(data$group),
                    multiple = TRUE,
                    selected = c("GENERAL"))
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h2("IPC por grupo según dominio de estudio, 2008 - Mayo 2014"),
      plotOutput("distPlot")
    )
  )
))
