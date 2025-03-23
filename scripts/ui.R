library(shiny)
library(tidyverse)
library(nflverse)
library(ggrepel)

ui <- fluidPage(
  titlePanel("NFL Draft Picks and AV"),
  sidebarLayout(
    fluid = TRUE,
    sidebarPanel(
      selectInput("y_axis", "Select Y-axis:",
                  choices = c(
                    "Weighted Approximate Value" = "w_av", 
                    "Approximate Value per Year" = "av_per_year",
                    "Second Contract APY Cap Percentage" = "second_apy_cap_pct"
                  ),
                  selected = "w_av"),
      selectInput("position", "Position:",
                  choices = unique(all_draft_data$category),
                  selected = "QB", multiple = TRUE),
      sliderInput("round", "Round:",
                  min = min(all_draft_data$round),
                  max = max(all_draft_data$round),
                  value = range(all_draft_data$round),
                  step = 1),
      sliderInput("pick", "Pick:",
                  min = min(all_draft_data$pick),
                  max = max(all_draft_data$pick),
                  value = range(all_draft_data$pick)),
      
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
