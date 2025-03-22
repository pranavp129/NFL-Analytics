# Load libraries
library(tidyverse)
library(nflverse)
library(ggrepel)

# Load and process draft_picks data
draft_picks <- nflreadr::load_draft_picks(seasons = 1994:2024)

# Select appropiate features
draft_picks <- draft_picks %>% 
  select(round, pick, pfr_player_name, position, category, allpro, w_av) %>% 
  filter(!is.na(w_av))

# Edit Categories
draft_picks <- draft_picks %>%
  mutate(category = case_when(
    category == "OG" ~ "OL", # combine OG into OL category
    position %in% c("DL", "DT", "NT") ~ "DT", # combine DT and NT into DT
    position == "DE" ~ "DE", # Set DE to DE instead of DL
    position %in% c("S", "FS", "SAF") ~ "S", # combine FS and SAF into S,
    position %in% c("CB", "DB") ~ "CB", # combine CB and DB into CB
    TRUE ~ category  # Keep category value if no other conditions match
  ))

nfl_analytics_theme <- function(..., base_size = 12) {
  theme(
    text = element_text(family = "Roboto", size = base_size),
    axis.ticks = element_blank(),
    axis.title = element_text(color = "black",
                              face = "bold"),
    axis.text = element_text(color = "black",
                             face = "bold"),
    plot.title.position = "plot",
    plot.title = element_text(size = 16,
                              face = "bold",
                              color = "black",
                              vjust = .02,
                              hjust = 0.5),
    plot.subtitle = element_text(color = "black",
                                 hjust = 0.5),
    plot.caption = element_text(size = 8,
                                face = "italic",
                                color = "black"),
    panel.grid.minor = element_blank(),
    panel.grid.major =  element_line(color = "#d0d0d0"),
    panel.background = element_rect(fill = "#f7f7f7"),
    plot.background = element_rect(fill = "#f7f7f7"),
    panel.border = element_blank())
}