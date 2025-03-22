library(shiny)
library(tidyverse)
library(nflverse)
library(ggrepel)

ui <- fluidPage(
  titlePanel("NFL Draft Picks and AV"),
  sidebarLayout(
    fluid = TRUE,
    sidebarPanel(
      selectInput("category", "Position:",
                  choices = unique(draft_picks$category),
                  selected = "QB", multiple = TRUE),
      selectInput("round", "Round:",
                  choices = c(unique(draft_picks$round), "All Rounds" = "all"),
                  selected = "all", multiple = TRUE),
      sliderInput("pick", "Pick:",
                  min = min(draft_picks$pick),
                  max = max(draft_picks$pick),
                  value = range(draft_picks$pick))
    ),
    
    mainPanel(
      tableOutput("myTable"),
      plotOutput("myPlot", width = "500px"),
      width = 6
    )
  )
)
