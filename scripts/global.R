# Load libraries
library(tidyverse)
library(nflverse)
library(ggrepel)

# Load and process draft_picks data
# NOTE: Starting with 1994 since this is when the 7 round draft format started
draft_picks <- nflreadr::load_draft_picks(seasons = 1994:2024)

# Select appropriate features
summary(draft_picks)

draft_picks <- draft_picks %>% 
  select(round, pick, pfr_player_name, position, category, allpro, w_av) %>% 
  filter(!is.na(w_av))

# Edit Positions
draft_picks <- draft_picks %>%
  mutate(category = case_when(
    category == "OG" ~ "OL", # combine OG into OL category
    position %in% c("DL", "DT", "NT") ~ "DT", # combine DT and NT into DT
    position == "DE" ~ "DE", # Set DE to DE instead of DL
    position %in% c("S", "FS", "SAF") ~ "S", # combine FS and SAF into S,
    position %in% c("CB", "DB") ~ "CB", # combine CB and DB into CB
    TRUE ~ category  # Keep category value if no other conditions match
  ))

