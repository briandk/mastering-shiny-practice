library(shiny)
library(vroom)
library(tidyverse)

download_er_data <- function() {
  dir.create("neiss")
  download("injuries.tsv.gz")
  download("population.tsv")
  download("products.tsv")
}

download <- function(name) {
  url <- "https://github.com/hadley/mastering-shiny/raw/main/neiss/"
  download.file(paste0(url, name), paste0("neiss/", name), quiet = TRUE)
}

injuries <- vroom::vroom("neiss/injuries.tsv.gz")
products <- vroom::vroom("neiss/products.tsv")
population <- vroom::vroom("neiss/population.tsv")

selected <- injuries %>% filter(prod_code == 649)
nrow(selected)

selected |>
  count(location, wt = weight, sort = TRUE)

selected |>
  count(body_part, wt = weight, sort = TRUE)

selected |>
  count(diag, wt = weight, sort = TRUE)

summary <- selected |>
  count(age, sex, wt = weight)
summary

summary |>
  ggplot(aes(age, n, color = sex)) +
  geom_line() +
  labs(y = "Estimated number of injuries")

summary <- selected |>
  count(age, sex, wt = weight) |>
  left_join(population, by = c("age", "sex")) |>
  mutate(rate = n / (population * 1e4))

summary %>%
  ggplot(aes(age, rate, colour = sex)) +
  geom_line(na.rm = TRUE) +
  labs(y = "Injuries per 10,000 people")

selected |>
  sample_n(10) |>
  pull(narrative)
