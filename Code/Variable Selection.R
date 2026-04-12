library(readr)

coef_df %>% slice(-c(11:31)) -> coef_df

var <- list(coef_df$Variable)

write.csv(var, "variables.csv", row.names = FALSE)
