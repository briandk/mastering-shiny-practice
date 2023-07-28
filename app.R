library(shiny)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  verbatimTextOutput("model_structure"),
  tableOutput("static"),
  dataTableOutput("dynamic"),
)
server <- function(input, output, session) {
  output$static <- renderTable(head(mtcars))
  output$dynamic <- renderDataTable(mtcars, options = list(pageLength = 5))
  output$model_structure <- renderPrint(dplyr::glimpse(mtcars))
}

shinyApp(ui, server)
