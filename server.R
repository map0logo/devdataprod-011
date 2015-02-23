
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(reshape2)
library(scales)

load("./data.Rdata")

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({

      # Select cities and domains
      cities <- unlist(input$cities)
      domains <- unlist(input$domains)
      
      start = input$dates[1]
      end = input$dates[2]
      
      # Melt data
      ts <- data[data$group %in% domains & data$date >= start & data$date <= end,
                 c(cities, "date", "group")]
      ts <- ts[order(ts$date), ]
      meltts <- melt(ts, id="date", id.vars = c("date","group"))
      
      # Graphic
      ggplot(meltts, aes(x=date, y=value, colour=variable)) + geom_line() +
          scale_x_date(labels = date_format("%b-%Y")) +
          xlab("") + ylab("IPC (BASE DICIEMBRE 2007=100)") + 
          facet_grid(group ~ ., scales = "free")

  })

})
