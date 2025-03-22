# load libraries
library(tidyverse)
library(nflverse)
library(ggrepel)

# get draft pick data and select features
draft_picks <- nflreadr::load_draft_picks(seasons = 1994:2024)
data <- draft_picks %>% 
  select(round, pick, pfr_player_name, position, category, allpro, w_av) %>% 
  filter(!is.na(w_av) & !is.na(pfr_player_name))

# find number of positions in position col
unique(data$position)
length(unique(data$position))
# there are 26 different positions in the data
# "DT"  "RB"  "QB"  "DE"  "LB"  "DB"  "T"   "G"   "WR"  "FB"  "C"   "NT"  "TE" 
# "K"   "P"   "DL"  "OL"  "OLB" "CB"  "S"   "ILB" "LS"  "OT"  "SAF" "OG"  "FS" 

# find number of positions in category col
unique(draft_picks$category)
length(unique(draft_picks$category))
# there are 13 different categories
# "DL" "RB" "QB" "LB" "DB" "OL" "WR" "TE" "K"  "P"  "LS" "OG" "FS"

# Looking to see what OG category is.
draft_picks %>% 
  filter(position == "OG")

# Looking to see what OG category is.
draft_picks %>% 
  filter(position == "OL")

# Edit Categories
data <- data %>%
  mutate(category = case_when(
    category == "OG" ~ "OL", # combine OG into OT category
    position %in% c("DL", "DT", "NT") ~ "DT", # combine DT and NT into DT
    position == "DE" ~ "DE", # Set DE to DE instead of DL
    position %in% c("S", "FS", "SAF") ~ "S", # combine FS and SAF into S,
    position %in% c("CB", "DB") ~ "CB", # combine CB and DB into CB
    TRUE ~ category  # Keep category value if no other conditions match
  ))

# find number of categories in categories col after changes
unique(data$category)
length(unique(data$category))

# getting data sorted by position and round
data_by_round <- data %>% 
  group_by(category, round) %>% 
  summarise(mean_av = mean(w_av),
            count = n())

test_data <- data %>% filter(category %in% c("QB", "DE"))

ggplot(data = test_data, aes(x = pick, y = w_av)) +
  geom_point(aes(fill = category), shape=23, color="grey", size=1) +
  geom_smooth(aes(color = category), method = "lm", se = FALSE, linetype = "solid", size = 1.5) +
  scale_x_continuous(breaks = seq(0, 32*8, by = 32),
                     limits = c(min(test_data$pick), max(test_data$pick))) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 6)) +
  labs(x = "NFL Draft Pick Number",
       y = "Approximate Value",
       title = "Value by Draft Pick",
       subtitle = "Draft Pick vs. Approximate Value (AV)",
       caption = "**Made by: Pranav Pitchala; Data: Pro Football Reference**",
       color = "Position") +
  nfl_analytics_theme()
