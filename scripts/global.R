# Load libraries
library(tidyverse)
library(nflverse)
library(ggrepel)

# Load and process draft_picks data
# NOTE: Starting with 1994 since this is when the 7 round draft format with 32 teams started
draft_picks <- nflreadr::load_draft_picks(seasons = 1994:2024)

summary(draft_picks)

# creating a draft pick id to remove inconsistencies with gsis_id
draft_picks <- draft_picks %>%
  mutate(draft_pick_id = paste0(season, "-", pick))

# Select appropriate features
draft_picks <- draft_picks %>% 
  select(draft_pick_id, gsis_id, pfr_player_id, pfr_player_name, round, pick, position, category, allpro, w_av, season, to) %>% 
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

# find number of seasons played
draft_picks <- draft_picks %>% 
  filter(!is.na(to)) %>% 
  mutate(seasons_played = to - season + 1)

# create a new stat called AV per year
draft_picks <- draft_picks %>% 
  mutate(av_per_year = w_av / seasons_played)

summary(draft_picks)

# Load and filter contract data
# Remove undrafted players 
nfl_contracts <- nflreadr::load_contracts() %>%
  filter(!is.na(draft_overall))

# remove players drafted before 1994
nfl_contracts <- nfl_contracts %>%
  filter(draft_year >= 1994)

summary(nfl_contracts)

# creating a draft pick id to remove inconsistencies with gsis_id
nfl_contracts <- nfl_contracts %>%
  mutate(draft_pick_id = paste0(draft_year, "-", draft_overall))

# Get contract numbers for each player
contracts_numbered <- nfl_contracts %>%
  arrange(gsis_id, year_signed) %>%
  group_by(gsis_id) %>%
  mutate(contract_number = row_number()) %>%
  ungroup()

# Extract first contracts for all players but exclude those who are active, since these players aren't eligible for a second contract yet
first_contracts <- contracts_numbered %>%
  filter(contract_number == 1 & !is_active) %>%  # Exclude active first contracts
  select(draft_pick_id, gsis_id, player, first_apy_cap_pct = apy_cap_pct) # Keep first contract info

# Extract second contracts if available
second_contracts <- contracts_numbered %>%
  filter(contract_number == 2) %>%
  select(gsis_id, player, apy_cap_pct) # Keep second contract info

# Merge first contracts with second contracts, ensuring all players are included
final_second_contracts <- first_contracts %>%
  left_join(second_contracts, by = c("gsis_id", "player")) %>%
  mutate(second_apy_cap_pct = ifelse(is.na(apy_cap_pct), 0, apy_cap_pct)) %>% # Set to 0 if no second contract
  select(draft_pick_id, gsis_id, player, second_apy_cap_pct)

# merge draft picks and final second contracts
all_draft_data <- final_second_contracts %>%
  left_join(draft_picks, by = "draft_pick_id")

# remove na's
all_draft_data <- all_draft_data %>% 
  filter(!is.na(w_av))