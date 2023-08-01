library(shiny)
library(vroom)
library(tidyverse)
library(forcats)

# download_er_data <- function() {
#   if (!dir.exists("neiss")) {
#     dir.create("neiss")
#     download("injuries.tsv.gz")
#     download("population.tsv")
#     download("products.tsv")
#   }
# }
#
# download <- function(name) {
#   url <- "https://github.com/hadley/mastering-shiny/raw/main/neiss/"
#   download.file(paste0(url, name), paste0("neiss/", name), quiet = TRUE)
# }

injuries <- vroom::vroom("neiss/injuries.tsv.gz")
products <- vroom::vroom("neiss/products.tsv")
population <- vroom::vroom("neiss/population.tsv")

selected <- injuries %>% filter(prod_code == 649)
prod_codes <- setNames(products$prod_code, products$title)
summary <- selected |>
  count(age, sex, wt = weight)

count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := forcats::fct_lump(forcats::fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

###

ui <- fluidPage(
  fluidRow(column(
    8,
    selectInput("code", "Product", choices = prod_codes, width = "100%"),
  ), column(4, selectInput(
    "y", "Y axis", c("rate", "count")
  ))),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(column(12, plotOutput("age_sex"))),
  fluidRow(
    column(2, actionButton("story", "Tell me a story")),
    column(10, textOutput("narrative")),
  )
)

server <- function(input, output, session) {
  selected <- reactive({
    injuries |>
      filter(prod_code == input$code)
  })

  narrative_sample <- eventReactive({
    list(input$story, selected())
    selected() |> pull(narrative) |> sample(1)
  })

  output$diag <- renderTable({
    selected() |> count_top(diag)
  }, width = "100%")
  output$body_part <- renderTable({
    selected() |> count_top(body_part)
  }, width = "100%")
  output$location <- renderTable({
    selected() |> count_top(location)
  }, width = "100%")

  summary <- reactive({
    selected() |>
      count(age, sex, wt = weight) |>
      left_join(population, by = c("age", "sex")) |>
      mutate(rate = n / (population * 1e4))
  })

  output$age_sex <- renderPlot({
    if (input$y == "count") {
      summary() |>  ggplot(aes(age, n, color = sex)) +
        geom_line() +
        labs(y = "Estimated number of injuries") +
        scale_color_brewer(type = "qual") +
        theme_light()
    } else {
      summary() |>
        ggplot(aes(age, rate, color = sex)) +
        geom_line(na.rm = TRUE) +
        labs(y = "Estimated number of injuries") +
        scale_color_brewer(type = "qual") +
        theme_light()
    }
  }, res = 96)
  output$narraative <- renderText(narrative_sample())
}

shinyApp(ui, server)
