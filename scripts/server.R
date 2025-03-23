library(shiny)
library(tidyverse)
library(nflverse)
library(ggrepel)
library(grid)

source("r scripts/theme.R")

server <- function(input, output) {
  
  # Function to rename y-axis label based on selection using switch
  getYAxisLabel <- function(y_axis) {
    switch(y_axis,
           "w_av" = "Weighted Approximate Value",
           "av_per_year" = "Weighted Approximate Value per Year",
           "second_apy_cap_pct" = "Second Contract APY Cap Percentage",
           y_axis)  # Default: return the y_axis itself if not recognized
  }
  
  filteredData <- reactive({
    all_draft_data %>%
      filter(
        round >= input$round[1] & round <= input$round[2],
        pick >= input$pick[1] & pick <= input$pick[2],
        position %in% input$position
      )
  })
  
  output$myPlot <- renderPlot({
    plotData <- filteredData() 
    
    ggplot(data = plotData, aes(x = pick, y = .data[[input$y_axis]])) +  
      geom_point(aes(fill = position), shape = 23, color = "grey", size = 1) + 
      geom_smooth(aes(color = position), method = "lm", se = FALSE, linetype = "solid", size = 1.5) +
      scale_x_continuous(breaks = seq(0, 32*8, by = 32),
                         limits = c(min(plotData$pick), max(plotData$pick))) +
      scale_y_continuous(breaks = scales::pretty_breaks(n = 6)) +
      # 
      labs(x = "NFL Draft Pick Number",
           y = getYAxisLabel(input$y_axis),  # Dynamic y-axis label
           title = "Value of NFL Draft Picks",
           subtitle = paste("Draft Pick vs.", getYAxisLabel(input$y_axis)),
           caption = "**Made by: Pranav Pitchala**
                      Data from: Pro Football Reference, Over the Cap.
                      Includes data from 1994-2024 (1994 was the start of the 7 round NFL draft era.
                      Players actively on a rookie contract are excluded.") +  
      theme(legend.position = "right") +
      nfl_analytics_theme()
  }, width = 500)
  
  output$myTable <- renderTable({
    resultTable <- filteredData() %>%
      group_by(position, round) %>%
      summarise(
        mean_value = mean(.data[[input$y_axis]], na.rm = TRUE),  
        count = n()
      ) %>%
      rename(
        "Position" = position,
        "Draft Round" = round,
        !!paste("Mean", getYAxisLabel(input$y_axis)) := mean_value,  
        "# of Players" = count
      ) %>% 
      as.data.frame()
    
    resultTable
  })
  
}
