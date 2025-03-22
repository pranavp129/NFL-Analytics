library(shiny)
library(tidyverse)
library(nflverse)
library(ggrepel)

server <- function(input, output) {
  
  filteredData <- reactive({
    draft_picks %>%
      filter(
        (input$round == "all" | round %in% input$round),
        pick >= input$pick[1] & pick <= input$pick[2],
        category %in% input$category
      )
  })
  
  output$myTable <- renderTable({
    resultTable <- filteredData() %>%
      group_by(category, round) %>%
      summarise(
        mean_av = mean(w_av),
        count = n()
      ) %>%
      rename(
        "Position" = category,
        "Draft Round" = round,
        "Mean AV" = mean_av,
        "# of Players" = count
      ) %>% 
      as.data.frame()
    
    resultTable
  })
  
  output$myPlot <- renderPlot({
    plotData <- filteredData() 

    ggplot(data = plotData, aes(x = pick, y = w_av)) +
      geom_point(aes(fill = category), shape=23, color="grey", size=1) +
      geom_smooth(aes(color = category), method = "lm", se = FALSE, linetype = "solid", size = 1.5) +
      scale_x_continuous(breaks = seq(0, 32*8, by = 32),
                         limits = c(min(plotData$pick), max(plotData$pick))) +
      scale_y_continuous(breaks = scales::pretty_breaks(n = 6)) +
      labs(x = "NFL Draft Pick Number",
           y = "Approximate Value",
           title = "Value by Draft Pick",
           subtitle = "Draft Pick vs. Approximate Value (AV)",
           caption = "**Made by: Pranav Pitchala; Data: Pro Football Reference**",
           color = "Position") +
      nfl_analytics_theme()
  }, width = 500)
}