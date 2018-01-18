library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("cosmo"),

    # Application title
    titlePanel("The effect of genetic drift on allele frequencies"),
    br(),

    # Sidebar with a slider input for number of bins
    fluidRow(
        column(
            4,
            numericInput(
                "Generations",
                "Number of generations",
                value = 100,
                width = 250
            ),
            numericInput(
                "Popsize",
                "Population size",
                value = 100,
                width = 250
            )
        ),
        column(
            4,
            sliderInput(
                inputId = "Allele_nb",
                label = "Number of alleles",
                min = 2,
                max = 10,
                value = 2,
                width = 250
            ),
            radioButtons(
                "Same",
                label = "Initial allele frequencies",
                choices = list("Equal" = 1 ,"Different" = 2),
                selected = 1
            )
        ),
        column(
            4,
            sliderInput(
                inputId = "Plot_nb",
                label = "Number of plots",
                min = 1,
                max = 20,
                value = 1,
                width = 250
            ),
            actionButton(
                "refresh",
                "Refresh"
            )
        )
    ),
    # Show a plot of the generated distribution
    fluidRow(
        column(12,
               plotOutput("drift_plot", height = "640px")
    ))))
