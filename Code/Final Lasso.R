# -----------------------------
# 1. Load required libraries
# -----------------------------
library(glmnet)

# -----------------------------
# 2. Load your dataset
# -----------------------------
data <- read.csv("filtered_timeseries_fifa_players.csv")

# نگاه at structure (important!)
str(data)

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