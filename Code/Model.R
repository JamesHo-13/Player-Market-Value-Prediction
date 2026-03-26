library(dplyr)

players <- read.csv("players_15.csv")

players_clean <- players %>%
  select(value_eur, overall, potential, age, wage_eur, 
         pace, shooting, passing, dribbling, defending, physic) %>%
  na.omit

model <- lm(value_eur ~ ., data = players_clean)

summary(model)

par(mfrow = c(2,2))
plot(model)

players_clean$log_value <- log(players_clean$value_eur)

model_log <- lm(log_value ~ overall + potential + age + wage_eur +
                  pace + shooting + passing + dribbling + defending + physic,
                data = players_clean)

summary(model_log)

model_simple <- lm(log_value ~ overall + potential + age + wage_eur,
                   data = players_clean)

summary(model_simple)