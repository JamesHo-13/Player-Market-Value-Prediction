library(readr)

#coef_df %>% slice(-c(11:31)) -> coef_df
coef_df %>% slice(-25) -> coef_df
coef_df %>% slice(-37) -> coef_df
#coef_df[19, ]

var <- list(coef_df$Variable)

write.csv(var, "variables.csv", row.names = FALSE)
