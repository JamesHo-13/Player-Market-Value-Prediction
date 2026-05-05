library(dplyr)
data <- read.csv("filtered_timeseries_fifa_players.csv")
df_15 <- read.csv("players_15.csv") %>% add_column(year = 2015, .after = 'long_name')
df_16 <- read.csv("players_16.csv") %>% add_column(year = 2016, .after = 'long_name')
df_17 <- read.csv("players_17.csv") %>% add_column(year = 2017, .after = 'long_name')
df_18 <- read.csv("players_18.csv") %>% add_column(year = 2018, .after = 'long_name')
df_19 <- read.csv("players_19.csv") %>% add_column(year = 2019, .after = 'long_name')
df_20 <- read.csv("players_20.csv") %>% add_column(year = 2020, .after = 'long_name')
df_21 <- read.csv("players_21.csv") %>% add_column(year = 2021, .after = 'long_name')
df_22 <- read.csv("players_22.csv") %>% add_column(year = 2022, .after = 'long_name')

all_players <- bind_rows(df_15, df_16, df_17, df_18, df_19, df_20, df_21, df_22)

write.csv(all_players, "all_players.csv", row.names = FALSE)

data <- data %>% 
  left_join(all_players %>% 
              select (sofifa_id, year, club_name), by = c("sofifa_id", "year")) %>% 
  relocate(club_name, .after = long_name)

write.csv(data, "filtered_timeseries_fifa_players.csv", row.names = FALSE)

data <- data %>% filter(long_name == "Lionel Andrés Messi Cuccittini")
