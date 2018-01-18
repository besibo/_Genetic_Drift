
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(gridExtra)
source("Drift.R")

shinyServer(function(input, output) {

    # plotHeight <- reactive(input$Plot_height)

    output$drift_plot <- renderPlot({

        input$refresh

        # generate initial allele frequencies
        diff <- ifelse(input$Same==1, FALSE, TRUE)
        freq <- sum_to_one(n = input$Allele_nb, different = diff)

        ggpl <- list()
        for (i in 1:input$Plot_nb) {
            # generate allele frequencies
            dat <- drift(pop_size = input$Popsize,
                         allele_freq = freq,
                         generations = input$Generations)

            # draw the plot
            ggpl[[i]] <- ggdrift(dat, pop_size = input$Popsize)
        }

        do.call("grid.arrange", ggpl)
    })

})
