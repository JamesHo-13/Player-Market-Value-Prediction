# -----------------------------
# 1. Load required libraries
# -----------------------------
library(glmnet)
library(ggplot2)
library(tidyverse)
library(dplyr)

# -----------------------------
# 2. Load your dataset
# -----------------------------
data <- read.csv("filtered_timeseries_fifa_players.csv")

# نگاه at structure (important!)
str(data)

data <- select(data, -57:-98)
data$sofifa_id <- NULL

# -----------------------------
# 3. Clean / prepare data
# -----------------------------
# Remove non-numeric columns if needed (e.g., names, IDs)
# Keep only numeric variables for glmnet
numeric_data <- data[, sapply(data, is.numeric)]

# Remove rows with missing values
numeric_data <- na.omit(numeric_data)

# -----------------------------
# 4. Define X and Y variables
# -----------------------------
# Change 'value_eur' to your target variable if different
y_var <- numeric_data$value_eur

# Remove target from predictors
x_vars <- model.matrix(value_eur ~ ., numeric_data)[, -1]

# -----------------------------
# 5. Create lambda sequence
# -----------------------------
lambda_seq <- 10^seq(2, -2, by = -0.1)

# -----------------------------
# 6. Train/Test Split
# -----------------------------
set.seed(86)
train <- sample(1:nrow(x_vars), nrow(x_vars) / 2)

x_train <- x_vars[train, ]
y_train <- y_var[train]

x_test <- x_vars[-train, ]
y_test <- y_var[-train]

# -----------------------------
# 7. Cross-validation for best lambda
# -----------------------------
cv_output <- cv.glmnet(
  x_train, y_train,
  alpha = 1,               # LASSO
  lambda = lambda_seq,
  nfolds = 5
)

# Best lambda
best_lam <- cv_output$lambda.min
print(best_lam)

# -----------------------------
# 8. Train final LASSO model
# -----------------------------
lasso_best <- glmnet(
  x_train, y_train,
  alpha = 1,
  lambda = best_lam
)

# -----------------------------
# 9. Make predictions
# -----------------------------
pred_train <- predict(lasso_best, s = best_lam, newx = x_train)
pred_test  <- predict(lasso_best, s = best_lam, newx = x_test)

# -----------------------------
# 10. R-squared function
# -----------------------------
rsq_function <- function(actual, preds) {
  rss <- sum((preds - actual)^2)
  tss <- sum((actual - mean(actual))^2)
  return(1 - rss/tss)
}

# Compute R²
rsq_train <- rsq_function(y_train, pred_train)
rsq_test  <- rsq_function(y_test, pred_test)

cat("Train R²:", rsq_train, "\n")
cat("Test R²:", rsq_test, "\n")

# -----------------------------
# 11. Compare actual vs predicted
# -----------------------------
final <- data.frame(
  Actual = y_test,
  Predicted = as.numeric(pred_test)
)

head(final)

# -----------------------------
# 12. Important variables (coefficients)
# -----------------------------
coef(lasso_best)

# -----------------------------
# 13. Plot
# -----------------------------

# Plot coefficient paths
# plot(lasso_best, xvar = "lambda", label = TRUE)
# 
# plot(cv_output)
# 
# Extract coefficients
coef_matrix <- coef(lasso_best)

# Convert to dataframe
coef_df <- data.frame(
  Variable = rownames(coef_matrix),
  Coefficient = as.numeric(coef_matrix)
)

# Remove zero coefficients
coef_df <- coef_df[coef_df$Coefficient != 0, ]

# Remove intercept
coef_df <- coef_df[coef_df$Variable != "(Intercept)", ]

# Sort by importance
coef_df <- coef_df[order(abs(coef_df$Coefficient), decreasing = TRUE), ]

# Take top 15 most important variables
top_coef <- head(coef_df, 15)
# 
# # Plot
# barplot(
#   top_coef$Coefficient,
#   names.arg = top_coef$Variable,
#   las = 2,
#   main = "Top 15 LASSO Coefficients",
#   cex.names = 0.7
# )
# 
# ggplot(top_coef, aes(x = reorder(Variable, Coefficient), y = Coefficient)) +
#   geom_bar(stat = "identity") +
#   coord_flip() +
#   labs(title = "Top 15 LASSO Coefficients",
#        x = "Variables",
#        y = "Coefficient Value") +
#   theme_minimal()

ggplot(top_coef, aes(x = reorder(Variable, Coefficient), 
                     y = Coefficient,
                     fill = Coefficient > 0)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  scale_fill_manual(values = c("red", "blue")) +
  labs(title = "LASSO Coefficients (Positive vs Negative)",
       x = "Variables",
       fill = "Positive Effect") +
  theme_minimal()

# -----------------------------
# Fixed Code
# -----------------------------
#library(glmnet)

# -----------------------------
# 2. Load data
# -----------------------------
data <- read.csv("filtered_timeseries_fifa_players.csv")

# -----------------------------
# 3. Clean data
# -----------------------------
# Remove ID columns (IMPORTANT)
data <- select(data, -57:-98, -6, -9)
data$sofifa_id <- NULL

# Keep numeric columns only
numeric_data <- data[, sapply(data, is.numeric)]

# Remove missing values
numeric_data <- na.omit(numeric_data)

# -----------------------------
# 4. Log-transform target
# -----------------------------
y_var <- log(numeric_data$value_eur)

# Create predictors
numeric_data <- as.data.frame(scale(numeric_data))
x_vars <- model.matrix(value_eur ~ ., numeric_data)[, -1]

# -----------------------------
# Testing
lambda_seq <- 10^seq(3, -4, by = -0.1)
# -----------------------------

# -----------------------------
# 5. Lambda sequence
# -----------------------------
#lambda_seq <- 10^seq(2, -2, by = -0.1)

# -----------------------------
# 6. Train/Test split
# -----------------------------
set.seed(86)
train <- sample(1:nrow(x_vars), nrow(x_vars) / 2)

x_train <- x_vars[train, ]
y_train <- y_var[train]

x_test <- x_vars[-train, ]
y_test <- y_var[-train]

# -----------------------------
# 7. Cross-validation (Elastic Net)
# -----------------------------
cv_output <- cv.glmnet(
  x_train, y_train,
  alpha = 0.5,              # ✅ Elastic Net
  lambda = lambda_seq,
  nfolds = 5,
  standardize = TRUE        # ✅ Ensure scaling
)

# Best lambda
best_lam <- cv_output$lambda.min
print(best_lam)

# -----------------------------
# 8. Train final model
# -----------------------------
elastic_best <- glmnet(
  x_train, y_train,
  alpha = 0.5,
  lambda = best_lam
)

# -----------------------------
# 9. Predictions (log scale)
# -----------------------------
pred_train_log <- predict(elastic_best, s = best_lam, newx = x_train)
pred_test_log  <- predict(elastic_best, s = best_lam, newx = x_test)

# -----------------------------
# Testing
# Smearing estimator
smear_factor <- mean(exp(y_train - pred_train_log))

# Apply correction
pred_train <- exp(pred_train_log) * smear_factor
pred_test  <- exp(pred_test_log) * smear_factor
# -----------------------------

# # Convert back to original scale
# pred_train <- exp(pred_train_log)
# pred_test  <- exp(pred_test_log)

# Actual values (back to original scale)
y_train_actual <- exp(y_train)
y_test_actual  <- exp(y_test)

# -----------------------------
# 10. R-squared function
# -----------------------------
rsq_function <- function(actual, preds) {
  rss <- sum((preds - actual)^2)
  tss <- sum((actual - mean(actual))^2)
  return(1 - rss/tss)
}

# Compute R²
rsq_train <- rsq_function(y_train_actual, pred_train)
rsq_test  <- rsq_function(y_test_actual, pred_test)

cat("Train R²:", rsq_train, "\n")
cat("Test R²:", rsq_test, "\n")

# -----------------------------
# 11. Compare actual vs predicted
# -----------------------------
final <- data.frame(
  Actual = y_test_actual,
  Predicted = as.numeric(pred_test)
)

head(final)

# -----------------------------
# 12. Coefficients
# -----------------------------
coef(elastic_best)

# -----------------------------
# 13. Plots (recommended)
# -----------------------------
# Cross-validation plot
# plot(cv_output)
# 
# # Coefficient paths
# plot(elastic_best, xvar = "lambda", label = TRUE)

# -----------------------------
# Extract coefficients
# -----------------------------
coef_matrix <- coef(elastic_best)

coef_df <- data.frame(
  Variable = rownames(coef_matrix),
  Coefficient = as.numeric(coef_matrix)
)

# -----------------------------
# Clean coefficients
# -----------------------------
# Remove zeros
coef_df <- coef_df[coef_df$Coefficient != 0, ]

# Remove intercept
coef_df <- coef_df[coef_df$Variable != "(Intercept)", ]

# OPTIONAL: remove tiny coefficients (noise from log model)
#coef_df <- coef_df[abs(coef_df$Coefficient) > 0.01, ]

# -----------------------------
# Sort by importance
# -----------------------------
coef_df <- coef_df[order(abs(coef_df$Coefficient), decreasing = TRUE), ]

# Select top 15
top_coef <- head(coef_df, 15)

# -----------------------------
# Base R bar plot
# -----------------------------
# barplot(
#   top_coef$Coefficient,
#   names.arg = top_coef$Variable,
#   las = 2,
#   cex.names = 0.7,
#   main = "Top 15 Elastic Net Coefficients (Log Model)"
# )
# 
# ggplot(top_coef, aes(x = reorder(Variable, Coefficient), y = Coefficient)) +
#   geom_bar(stat = "identity") +
#   coord_flip() +
#   labs(
#     title = "Top 15 Most Important Variables (Elastic Net)",
#     x = "Variables",
#     y = "Coefficient (Log Scale Effect)"
#   ) +
#   theme_minimal()

ggplot(coef_df, aes(x = reorder(Variable, Coefficient), 
                     y = Coefficient,
                     fill = Coefficient > 0)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  scale_fill_manual(values = c("red", "blue")) +
  labs(
    title = "Elastic Net Coefficients",
    x = "Variables",
    y = "Effect on Player Value",
    fill = "Positive Effect"
  ) +
  theme_minimal()

