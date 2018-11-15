#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# The ui and server have to be there

library(shiny)
library(tidyverse)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
str(bcl)
#a <- 5
#print(a^2)

# Define UI for application that draws a histogram
ui <- fluidPage(
  # Can't put anything here that doesn't return html stuff
  titlePanel("BC Liquor price app",
             windowTitle = "BCL app"),
  sidebarLayout(
    sidebarPanel(sliderInput(inputId = "priceInput", label = "Select your desired price range.",
                             min = 0, max = 100, value = c(15, 30), pre = "$"),
                 radioButtons(inputId = "typeInput", label = "Select your type",
                              choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                              selected = "WINE")),
    mainPanel(
      plotOutput(outputId = "price_hist"),
      tableOutput(outputId = "bcl_data")
    )
  )
  #"This is some text",
  #br(),
  #"This is more text",
  #tags$h1("Level 1 header"),
  #h1(em("Level 1 header, part 2")),
  #HTML("<h1>Level 1 header, part 3</h1>"),
  #tags$blockquote("Thank you dinasours for showing us that bigger isn't always better",
  #                cite = "Someone"),
  #tags$code("foo <- function(x) {\"hahaha\"}"),
  #print(a)
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  observe(print(input$priceInput))
  bcl_filtered <- reactive(bcl %>%
    filter(Price < input$priceInput[2],
           Price > input$priceInput[1],
           Type == input$typeInput))
  output$price_hist <- renderPlot({
    bcl_filtered() %>%
      #filter(Price < input$priceInput[2],
      #       Price > input$priceInput[1],
      #       Type == input$typeInput) %>%
      ggplot(aes(Price)) +
      geom_histogram()
  })
  output$bcl_data <- renderTable({
    bcl_filtered() #%>%
      #filter(Price < input$priceInput[2],
      #       Price > input$priceInput[1],
      #       Type == input$typeInput)
  })
}

# Run the application
shinyApp(ui = ui, server = server)

