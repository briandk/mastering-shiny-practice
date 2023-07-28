library(shiny)
library(ggplot2)
library(lubridate)

datasets <- c("economics", "faithfuld", "seals")
ui <- fluidPage(
  selectInput("state", "What's your favourite state?", state.name,
              multiple = TRUE),
  actionButton("click", "Click me!"),
  actionButton("drink", "Drink me!", icon = icon("cocktail")),
  textInput("name", "What is your name?", placeholder = "Your Name"),
  sliderInput(
    "delivery_window",
    "When should we deliver?",
    min = lubridate::ymd("2023-07-01"),
    max = lubridate::ymd("2023-07-31"),
    value = lubridate::ymd("2022-07-10"),
    width = "100%"
  ),
  sliderInput(
    "year",
    "years since 1900",
    value = 5,
    min = 0,
    max = 100,
    step = 5,
    animate = TRUE,
  )
)

server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:ggplot2") |>
      head()
  })
  output$summary <- renderTable({
    dataset()
  })
  output$plot <- renderPlot({
    plot(dataset())
  }, res = 96)
}

shinyApp(ui, server)
