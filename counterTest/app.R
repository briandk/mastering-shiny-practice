#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  actionButton(
    "btn",
    "Click Here to Increment"
  ),
  textInput("firstname", ""),
  textInput("lastname", ""),
  actionButton("backward", "Backward"),
  actionButton("forward", "Forward"),
  textOutput("counterOutput"),
  textOutput("counter")
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  state <- reactiveValues()
  state$counter <- 2

  output$counterOutput <- renderText({
    mtcars[input$btn, ] |> unlist()
  })

  # state <- reactive({
  #   if (input$btn %% 5 == 0) {
  #     TRUE
  #   } else {
  #     FALSE
  #   }
  # })

  observeEvent(input$btn, {
    message("Entered Observe Event for Button")
    fn <- isolate(input$firstname)
    ln <- isolate(input$lastname)
    fullname <- paste(fn, ln)
    message(fullname)
  })

  observeEvent(c(input$forward), {
    state$counter <- min(state$counter + 1, dim(mtcars)[1])
  })

  observeEvent(c(input$backward), {
    state$counter <- max(state$counter - 1,  1)
  })

  output$counter <- renderText(state$counter)
}

# Run the application
shinyApp(ui = ui, server = server)
