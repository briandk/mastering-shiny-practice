library(ggplot2)
library(glue)
library(shiny)

ui <- fluidPage(
  fluidPage(
    titlePanel(renderText("obs")),
    sidebarLayout(
      sidebarPanel(
        sliderInput(
          "obs",
          "Observations:",
          min = 0,
          max = dim(mtcars)[1],
          value = 32,
          step = 1
        )
      ),
      mainPanel(
        fluidRow(plotOutput("distPlot")),
        fluidRow(verbatimTextOutput("obs"))
      )
    )
  )
)

server <- function(input, output, session) {
  mtcars_subset <- reactive({
    mtcars[1:input$obs, ]
  })
  output$obs <- renderText({
    # input$obs
    mtcars_subset() |>
      unlist()
  })

  # output$distPlot <- renderPlot(
  #   ggplot() +
  #     geom_point(aes(hp, mpg), data = mtcars_subset())
  # )
  output$distPlot <- renderPlot(
    plot(mtcars_subset()$hp, mtcars_subset()$mpg)
  )
}

shinyApp(ui, server)
