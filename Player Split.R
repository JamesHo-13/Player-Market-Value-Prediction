library(tidyverse)
library(dplyr)

players <- read_csv("players_15.csv", na = c('', 'NA', 'missing'))
head(players)

column_names <- colnames(players)
print(column_names)

attack_cols <- c("ST", "CF", "LW", "RW")
mid_cols    <- c("CM", "CAM", "CDM", "LM", "RM")
def_cols    <- c("CB", "LB", "RB", "LWB", "RWB")

players_grouped <- players %>%
  rowwise() %>%
  mutate(
    attack_score = max(c_across(all_of(attack_cols)), na.rm = TRUE),
    mid_score    = max(c_across(all_of(mid_cols)), na.rm = TRUE),
    def_score    = max(c_across(all_of(def_cols)), na.rm = TRUE),
    
    group = case_when(
      attack_score >= mid_score & attack_score >= def_score ~ "Attacker",
      mid_score >= attack_score & mid_score >= def_score ~ "Midfielder",
      TRUE ~ "Defender"
    )
  ) %>%
  ungroup()

table(players_grouped$group)

attackers   <- filter(players_grouped, group == "Attacker")
midfielders <- filter(players_grouped, group == "Midfielder")
defenders   <- filter(players_grouped, group == "Defender")
