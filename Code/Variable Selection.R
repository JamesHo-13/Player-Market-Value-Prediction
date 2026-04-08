library(readr)

var <- list(coef_df$Variable)

write.csv(var, "variables.csv", row.names = FALSE)