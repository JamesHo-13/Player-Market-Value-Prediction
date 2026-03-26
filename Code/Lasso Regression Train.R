library(glmnet)

data <- read.csv("filtered_timeseries_fifa_players.csv")
data <- na.omit(data)

#x_vars <- data[, sapply(data, is.numeric)]
#x_vars <- x_vars[, colnames(x_vars) != "value_eur"]
#x_vars <- as.matrix(x_vars)

x_vars <- model.matrix(value_eur~. , data)[,-1]
y_var <- data$value_eur
lambda_seq <- 10^seq(2, -2, by = -0.1)

# Splitting the data into train and test
set.seed(86)
train <- sample(1:nrow(x_vars), nrow(x_vars)/2)
test <- setdiff(1:nrow(x_vars), train)

x_test <- x_vars[test, ]
y_test <- y_var[test]

# Cross-validation to find best lambda
cv_output <- cv.glmnet(x_vars[train, ], y_var[train],
                       alpha = 1,
                       lambda = lambda_seq,
                       nfolds = 5)

# Best lambda
best_lam <- cv_output$lambda.min
best_lam

# Fit lasso with best lambda
lasso_best <- glmnet(x_vars[train, ], y_var[train],
                     alpha = 1,
                     lambda = best_lam)

# Predictions
pred <- predict(lasso_best, s = best_lam, newx = x_test)

# Combine actual vs predicted
final <- cbind(actual = y_test, predicted = pred)
head(final)

# R-squared calculation
rss <- sum((pred - y_test)^2)
tss <- sum((y_test - mean(y_test))^2)
rsq <- 1 - rss/tss
rsq

# Coefficients
coef(lasso_best)