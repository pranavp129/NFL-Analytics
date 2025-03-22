library(shiny)
library(tidyverse)
library(nflverse)
library(ggrepel)

ui <- fluidPage(
  titlePanel("NFL Draft Picks and AV"),
  sidebarLayout(
    fluid = TRUE,
    sidebarPanel(
      selectInput("position", "Position:",
                  choices = unique(draft_picks$category),
                  selected = "QB", multiple = TRUE),
      selectInput("round", "Round:",
                  choices = c(unique(draft_picks$round), "All Rounds" = "all"),
                  selected = "all", multiple = TRUE),
      sliderInput("pick", "Pick:",
                  min = min(draft_picks$pick),
                  max = max(draft_picks$pick),
                  value = range(draft_picks$pick)),
      
      # Add a description about AV
      br(), # line break for spacing
      h4("What is AV?"),
      p("AV (Approximate Value) is a metric used to measure a player's career value to a team. It attempts to estimate a player's overall contribution to their team across all seasons in a single number. A higher AV indicates a more valuable player, based on performance over time. For more details, visit the",
        a(href = "https://www.pro-football-reference.com/about/approximate_value.htm", "Pro Football Reference website"), ".")
      
    ),
    
    mainPanel(
      plotOutput("myPlot", width = "500px"),
      tableOutput("myTable"),
      width = 6
    )
  )
)
