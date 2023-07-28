library(shiny)

ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", label = "and y is", min = 1, max = 50, value = 30),
  "then x times y is",
  textOutput("product")
)

server <- function(input, output, session) {
  x <- reactive({
    get(input$x)
  })
  output$product <- renderText({
    input$x * input$y
  })
}

shinyApp(ui, server)
# Run the application
shinyApp(ui = ui, server = server)
